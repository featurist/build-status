express = require 'express'
argv = require 'optimist'.default 'p' '4000'.alias 'p' 'port'.demand('teamcity').argv
compiler = require 'connect-compiler'
httpism = require 'httpism'
xml2js = require 'xml2js'
xml parser = new (xml2js.Parser)

serve directory (dir) =
    cache dir = "#(dir)/.cache"
    app = express ()
    app.use (express.logger ())
    app.use (compiler {
        enabled [ 'less', 'pogo' ]
        src = dir
        dest = cache dir
    })
    app.use (express.static (dir))
    app.use (express.static (cache dir))
    app.set 'view engine' 'ejs'

    get (url, block) = app.get (url) @(req, res)
        block (req, res) @(error, result)
            if (error)
                res.send (500, error.to string ())
            else
                res.send (result)

    app.get '/:id' @(req, res)
        res.render ('index', {build type = req.params.id})

    get '/status/:id' @(req, res)
        id = req.params.id
        res := httpism.get! "http://#(argv.teamcity)/guestAuth/app/rest/builds/buildType:#(id)"
        build details = xml parser.parse string! (res.body)

        status =       build details.build.$.status
        name =         build details.build.build type.0.$.name
        project name = build details.build.build type.0.$.project name
        revision =     build details.build.revisions.0.revision.0.$.version
        {status = status, revision = revision, name = name, project name = project name}

    app.listen (parse int (argv.p))

serve directory 'public'
console.log "serving http://localhost:#(argv.p)/"
