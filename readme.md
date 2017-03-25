# Laravel-BDD-CI featuring Behat and Travis-CI

[![Build Status](https://travis-ci.org/defenestrator/Laravel-BDD-CI.svg?branch=master)](https://travis-ci.org/defenestrator/Laravel-BDD-CI)

**A starter kit for Laravel 5 BDD with support for Travis-CI** 

I'm assuming you have a github account and a [Travis-CI](https://travis-ci.org) account linked to it.

Given that, it is safe to assume you know more or less how to configure your local development environment. 
Perhaps you've even installed Composer:

`curl -sS https://getcomposer.org/installer | php`

...then added the Laravel installer to your global composer requirements:

`composer global require "laravel/installer=~1.1"`

This tutorial will not cover configuring your local development environment, though the steps listed here should not 
impede any choice you may make in that regard.
 
**I strongly recommend using [Laravel Homestead](http://laravel.com/docs/5.0/homestead) for your local development.**

You will also need [Git](http://git-scm.com/downloads) installed locally, I hope that's obvious at this point. 

*Windows users please note:* I'm not going to re-write the whole article just for you, therefore I also recommend 
[Git Bash](https://github.com/msysgit/msysgit/releases) so you can enter shell commands in a sane manner whilst running 
Microsoft Corporation's Windows Operating System&trade;. 
Here's a bonus Windows [*ProTip*](https://www.udacity.com/wiki/ud775/git-bash-copy-paste); lest you think I dislike you.

Travis-CI is free for *public* repositories. Private repositories must pay, though services that support private 
repos at no charge do [exist](https://circleci.com/).

Now...breathe deeply and proceed.

### How to build it

#### Either

You _could_ clone/fork this repository, sync your repos with travis-ci and activate it.

#### Or

In terminal:
- install Laravel ~5.0.1 `laravel new blog`
- `cd blog`
- create a decent `.gitignore` file like 
[this one](https://gist.github.com/defenestrator/5ad679db122177888da5) to replace the minimal one in the project root.
- `git init`
- `mv .env.example .env`
- `php artisan key:generate`
- `touch behat.yml .travis.yml .env.behat`
- edit `composer.json` to add `"minimum-stability": "dev"` right before the closing brace.

Additionally edit your `"require-dev":` to look like this:
```json
"require-dev": {
    "phpunit/phpunit": "~4.4.5",
    "phpspec/phpspec": "~2.1",
    "behat/behat": "~3.0@dev",
    "behat/mink": "~1.7@dev",
    "behat/mink-extension": "~2.0@dev",
    "laracasts/behat-laravel-extension": "dev-master#205a3d2",
    "laracasts/testdummy": "dev-master#44807c5"
  },
  ```

Again in the terminal:    
- `composer install`
- `vendor/bin/behat --init`
- `git add .`

Edit `config/database.php` so that:
- `'default' => 'mysql',` becomes `'default' => env('DB_TYPE', 'sqlite')`
- and `'database' => storage_path().'/database.sqlite',` says `'database' => storage_path(env('SQLITE_DB', 'database.sqlite')),`
- Now add `DB_TYPE=mysql` to `.env`
- `.env.behat` will be excluded from git, if you used my .gitignore, and you should add to it:

```
APP_ENV=acceptance
APP_DEBUG=true

DB_TYPE=sqlite
SQLITE_DB=acceptance.sqlite

CACHE_DRIVER=file
SESSION_DRIVER=file
```

Then in Terminal:
`cp .env.behat .env.behat.travis`

Add this to your behat.yml:

```yaml
default:
  extensions:
    Laracasts\Behat\ServiceContainer\BehatExtension: ~
    Behat\MinkExtension\ServiceContainer\MinkExtension:
      default_session: laravel
      laravel: ~
```

Edit `.travis.yml` to read:


```yaml
language: php
php:
  - 5.6
sudo: false
before_script:
  # setup mysql (to test production) , and sqlite (for behat acceptance)
  # update composer,
  # then grab the packages,
  # chmod storage
  # migrate and seed db
  - mv .env.behat.travis .env.behat
  - chmod -R 777 storage
  - touch storage/acceptance.sqlite
  - composer self-update
  - composer install --prefer-source
  - php artisan key:generate
  #- npm install - if you want to use gulp/elixir
script:
  # Run them tests, y'all
  #- gulp # if you are running 'npm install' in before_script
  - phpunit tests/
  - vendor/bin/phpspec run -v
  - vendor/bin/behat --config behat.yml
```

Configure phpec.yml like so:
```yaml
suites:
    main:
        namespace: App
        psr4_prefix: App
        src_path: app
        spec_prefix: spec
```

Add four *use* lines to `features/bootstrap/FeatureContext.php` :
```php
use Behat\MinkExtension\Context\MinkContext;
use Laracasts\Behat\Context\Migrator;
use \Laracasts\Behat\Context\DatabaseTransactions;
use PHPUnit_Framework_Assert as PHPUnit;
```

Now run:
- `git remote add origin https://github.com/your-username/repo-name.git`
- `git commit -m "initial commit"`
- `git push -u origin master`

#### Finally:
**Go to [Travis-CI](https://travis-ci.org), synchronize your repositories, and turn this one on!**

You have now configured PHPUnit, PhpSpec, Behat, and Travis-CI for use with your Laravel application. 
This configuration will also allow different environments to remain de-coupled from a specific RDBMS 
through the addition of `DB_TYPE` and `SQLITE_DB` `.env` variables. Perhaps more importantly, you are now fully-equipped 
to do Story and Spec BDD, and you have automated Continuous Integration via Travis-CI.

Next; **filling in the blanks with practice tests.** 