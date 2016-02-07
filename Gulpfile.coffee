# Load all required libraries.
gulp       = require 'gulp'
plumber = require('gulp-plumber')
compass    = require 'gulp-compass'
browserSync = require('browser-sync')

coffee = require('gulp-coffee')

# config
name = 'overscores'
paths =
  scripts: ['coffee/*.coffee', '!client/external/**/*.coffee']
  images: 'client/img/**/*'
  style: 'sass/**/*.scss'

# functionalities
reload = browserSync.reload


gulp.task 'coffee', ->
  gulp.src('./coffee/*.coffee')
    .pipe(plumber
      errorHandler: (err) ->
        console.log(err)
        this.emit('end')
    )
    .pipe(coffee
      bare: true)
    .pipe(plumber.stop())
    .pipe(gulp.dest('js'))


gulp.task 'compass', ->
  gulp.src './sass/*.scss'
    .pipe(plumber(
      errorHandler: (err) ->
        console.log(err)
        this.emit('end')
    ))
    .pipe(compass
      config_file: 'compass/config.rb'
      css: 'css'
      sass: 'sass')
    .pipe(plumber.stop())
    .pipe gulp.dest('css')


# Copy the fonts using streams.
gulp.task 'copy', ->
  gulp.src 'app/fonts/*'
    .pipe gulp.dest 'www/fonts'

gulp.task 'watch',  ->
  # gulp.watch(paths.scripts, ['scripts'])
  browserSync(
    proxy: "#{name}.dev"
    open: false
    files: ["css/*.css","js/*.js"]
    logLevel: "debug"
  )
  gulp.watch(paths.style, ['compass'])
  gulp.watch(paths.scripts, ['coffee'])
  gulp.watch('css', browserSync.reload)
  gulp.watch('js', browserSync.reload)
  gulp.watch('**/*.php', ->
    browserSync.reload()
  )
  # gulp.watch(paths.images, ['images'])

# Default task call every tasks created so far.
gulp.task 'default', ['compass']
