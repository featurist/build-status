express = require 'express'
argv = require 'optimist'.default 'p' '4000'.alias 'p' 'port'.demand('teamcity').argv
compiler = require 'connect-compiler'
httpism = require 'httpism'
jquery = require 'jquery'

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

    get (url, block) = app.get (url) @(req, res)
        block (req, res) @(error, result)
            if (error)
                res.send (500, error.to string ())
            else
                res.send (result)

    get '/status/:id' @(req, res)
        id = req.params.id
        res = httpism.get! "http://#(argv.teamcity)/guestAuth/app/rest/builds/buildType:#(id)"
        $body = jquery(res.body)
        status = $body.attr 'status'
        name = $body.find 'buildType'.attr 'name'
        project name = $body.find 'buildType'.attr 'projectName'
        revision = $body.find 'revision'.attr 'version'
        {status = status, revision = revision, name = name, project name = project name}

    app.listen (parse int (argv.p))

serve directory 'public'
console.log "serving http://localhost:#(argv.p)/"
