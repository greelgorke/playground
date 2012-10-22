# Closeup

This is a small and easy utility to fight spaghetti code. Not like other libs i.E. async it does not aim to hide the
'event and callback' nature of JavaScript environments like DOM or Node. All it does is to reduce the need of
defining clojures, which is the main cause for callback-spaghetti:

    ```javascript
    http.createServer(function(req,res){
        User.find(req.param.id, function(err, user){
            if(err){
                return res.end(404);
            }
            user.views += 1;
            User.save(user, function(err){
                templateEngine.render('userProfile', user, function(err, result){
                   if(err) return res.end(500);
                   res.end(result, 'text/html');
                });
            });
        });
    });
    ```

Callbacks close over `req`, `res` and `user`. Instead:

    ```javascript
    var closeup = require('closeup');

    function templateCallback(err, result){
       if(err) return this.res.end(500);
       res.end(result, 'text/html');
    }

    function saveCallback(err){
        if(err){
            return res.end(400);
        }
        templateEngine.render('userProfile', user, closeup(templateCallbacl, this.res));
    }

    function findCallback(err, user){
        if(err){
            return res.end(404);
        }
        user.views += 1;
        User.save(user,closeup(saveCallback, {res: this.closeup.res, user: this.user}));
    }

    http.createServer(function(req,res){
        User.find(req.param.id, closeup(findCallback, {req:req,res:res}));
    });
    ```

the advantag is better reusability. Instead of writing callbacks again and again for closing over the state,
just pass it by. Renaming the closed-up values servers even more reuseability, because it allows to pass anything
with same signature to the callback:

    ```javascript
    var closeup = require('closeup');

    function outputHandler(err, data){
       if(err) return this.outputFunc(500);
       this.outputFunc(output, 'text/html');
    }

    function handler(req, res){
        templateEngine.render('userProfile', req.user, closeup(errHandler, res.end));
    }
    ```

The shown examples can be handled with a simple `Function#bind`
