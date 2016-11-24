# klausurFIX

(Hier fehlt eine Beschreibung.)

## Installation

Die klausurFIX Webapplikation ist in dem Web Application Framework
[Ruby on Rails](http://rubyonrails.org/) (kurz Rails), welches auf der
Programmiersprache [Ruby](https://www.ruby-lang.org/en/) basiert,
geschrieben. Um klausurFIX verwenden zu können, benötigt man eine Installation
von Ruby, Rails und den weiteren von klausurFIX benötigten Ruby
Paketen. Außerdem wird eine Datenbanksystem; es werden
[SQLite](https://www.sqlite.org/), [PostgreSQL](http://www.postgresql.org/)
und [MySQL](https://www.mysql.de/) unterstützt.

### Ruby Version Manager

Damit Ruby in der benötigten Version vorliegt und man sich nicht auf die
vom eingesetzten Betriebsystem abhängige Version verlassen muss, verwenden
wir den [Ruby Version Manager](http://rvm.io/) (kurz RVM), um Ruby zu
installieren.

```bash
curl -sSL https://get.rvm.io | bash -s stable
```

Der Aufruf der RVM Skripte wird vom Installationsskript automatisch in die
Konfigurationsdateien der Shell geschrieben. Sollte dies nicht
funktionieren, kann man diese manuell mit folgendem Befehl laden.

```bash
source $HOME/.rvm/scripts/rvm
```

Erzeugt `type rvm | head -n 1` die Ausgabe `rvm is a function`, dann ist
RVM erfolgreich installiert und wir können Ruby mit den folgenden Befehlen
installieren.

```bash
rvm install 2.1
rvm use 2.1 --default
```

### Rubygems, Gemset, Bundler

[Rubygems](https://rubygems.org/) ist das offizielle Paketsystem von
Ruby. Damit die für klausurFIX benötigten Gems (Pakete) in der richtigen
Version vorliegen, legen wir ein eigenes Gemset an. Dadurch ist
sichergestellt, dass auch andere Versionen des Gems installiert werden
können, ohne, dass dies mit der Version für klausurFIX in Konflikt gerät.

```bash
rvm gemset create klausurFIX
rvm use 2.1@klausurFIX
```

Damit ist die Umgebung vorbereitet und wir können mit der Installation der
nötigen Gems beginnen. [Bundler](http://bundler.io/) erleichtert diese
Aufgabe, weshalb wir es als erstes installieren. Alle weiteren Pakete
werden von Bundler automatisch installiert.

```bash
gem install rubygems-bundler
gem regenerate_binstubs
```

### klausurFIX

Wir können nun mit der Installation von klausurFIX beginnen. Dazu holen wir
via `git` die neueste Version und installieren mit Hifle von Bundler die
Abhängigkeiten. Diese Pakete werden nun in das oben angelegte Gemset
installiert und stehen somit isoliert von anderen Gems zur Verfügung. In
diesem Prozess wird auch Rails installiert. Natürlich ist darauf zu achten,
dass man sich in dem gewünschten Installationsort im Dateisystem befindet.

```bash
git clone https://github.com/fgrng/klausurFIX.git
cd klausurFIX
```

Anschließend wird die von klausurFIX verwendete Datenbank konfiguriert. Je
nach Datenbank müssen wir das Gemfile unter `./Gemfile` anpassen, da andere
Pakete benötigt werden. Die Konfiguration der Datenbank erfolgt in
`./config/database.yml`, die noch angelegt werden muss.

#### SQLite3

Um SQLite3 zu verwenden, muss SQLite3 auf unserem System installiert
sein. Dieser Vorgang unterscheidet sich von Betriebsystem zu Betriebsystem,
weshalb wir ihn hier nicht dokumentieren können.

Wir passen `./Gemfile` wie folgt an

```ruby
gem 'sqlite3'
# gem 'pg'
# gem 'mysql2'
```

und erstellen die Datenbankkonfiguration `./config/database.yml`.

```yaml
development:
  adapter: sqlite3
  database: db/development.sqlite3
  pool: 5
  timeout: 5000

test:
  adapter: sqlite3
  database: db/test.sqlite3
  pool: 5
  timeout: 5000

production:
  adapter: sqlite3
  database: db/production.sqlite3
  pool: 5
  timeout: 5000
```

#### PostgreSQL

Um PostgreSQL zu verwenden, muss SQLite3 auf unserem System installiert
sein. Dieser Vorgang unterscheidet sich von Betriebsystem zu Betriebsystem,
weshalb wir ihn hier nicht dokumentieren können.

Wir passen `./Gemfile` wie folgt an

```ruby
# gem 'sqlite3'
gem 'pg'
# gem 'mysql2'
```
und erstellen die Datenbankkonfiguration `./config/database.yml`.

```yaml
development:
  adapter: postgresql
  encoding: unicode
  database: klausurFIX_development
  pool: 5
  username: USERNAME
  password: PASSWORD

test:
  adapter: postgresql
  encoding: unicode
  database: klausurFIX_test
  pool: 5
  username: USERNAME
  password: PASSWORD

production:
  adapter: postgresql
  encoding: unicode
  database: klausurFIX_production
  pool: 5
  username: USERNAME
  password: PASSWORD
```
#### MySQL

Um PostgreSQL zu verwenden, muss SQLite3 auf unserem System installiert
sein. Dieser Vorgang unterscheidet sich von Betriebsystem zu Betriebsystem,
weshalb wir ihn hier nicht dokumentieren können.

Wir passen `./Gemfile` wie folgt an

```ruby
# gem 'sqlite3'
# gem 'pg'
gem 'mysql2'
```
und erstellen die Datenbankkonfiguration `./config/database.yml`.

```yaml
development:
  adapter: mysql2
  encoding: utf8
  database: klausurFIV_development
  username: USERNAME
  password: PASSWORD
  host: localhost
  socket: /tmp/mysql.sock

test:
  adapter: mysql2
  encoding: utf8
  database: klausurFIX_test
  username: USERNAME
  password: PASSWORD
  host: localhost
  socket: /tmp/mysql.sock

production:
  adapter: mysql2
  encoding: utf8
  database: klausurFIX_production
  username: USERNAME
  password: PASSWORD
  host: localhost
  socket: /tmp/mysql.sock
```

### Konfiguration und Umgebungsvariablen

Die Konfiguration von klausurFIX wird aus `./config/base.yml` gelesen,
die noch angelegt werden muss. Eine Beispieldatei findet sich unter
`./config/base.yml.example`.

```yaml
# Configuration File for klausurFIX rails app.
# Be sure to restart your server when you modify this file.

development:
  host: localhost
  port: 3000

  mailer_default_from: no-reply@example.com

  mailer_smtp_host: smtphost.com
  mailer_smtp_port: 587
  mailer_auth: :plain
  mailer_user: username@smtphost.com
  mailer_pw: super_secure_password
  mailer_startls: true

test:
  host: localhost
  port: 3000

  mailer_default_from: no-reply@example.com

  mailer_smtp_host: smtphost.com
  mailer_smtp_port: 587
  mailer_auth: :plain
  mailer_user: username@smtphost.com
  mailer_pw: super_secure_password
  mailer_startls: true

production:
  host: example.com
  port: 80

  mailer_default_from: no-reply@example.com

  mailer_smtp_host: smtphost.com
  mailer_smtp_port: 587
  mailer_auth: :plain
  mailer_user: username@smtphost.com
  mailer_pw: super_secure_password
  mailer_startls: true

```

Ausserdem muss für klausurFIX in der Datei `./config/secrets.yml` ein
sicherer (langer und zufälliger) Schlüssel eingetragen werden. Dieser wird
für die Verhinderung von CSRF Attacken verwendet.

## Setup

Schließlich rufen wir das Setup Skript auf, um die Installation von
klausurFIX abzuschließen.

```bash
./bin/setup
```
