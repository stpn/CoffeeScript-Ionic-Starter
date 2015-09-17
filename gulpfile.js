var gulp = require('gulp');
var gutil = require('gulp-util');
var bower = require('bower');
var concat = require('gulp-concat');
var minifyCss = require('gulp-minify-css');
var rename = require('gulp-rename');
var sh = require('shelljs');
var coffee = require('gulp-coffee');

var path = require('path');
var less = require('gulp-less');

var paths = {
  less: ['./www/**/*.less'],
  coffee: ['./www/**/*.coffee']

};

gulp.task('default', ['sass']);

gulp.task('less', function () {
  return gulp.src('./less/**/*.less')
    .pipe(less({
      paths: [ path.join(__dirname, 'less', 'includes') ]
    }))
    .pipe(gulp.dest('./public/css'));
});


gulp.task('coffee', function(done) {
  gulp.src(paths.coffee)
  .pipe(coffee({bare: true})
  .on('error', gutil.log.bind(gutil, 'Coffee Error')))
  .pipe(concat('application.js'))
  .pipe(gulp.dest('./www/js'))
  .on('end', done)
})

gulp.task('watch', function() {
  gulp.watch(paths.sass, ['sass'])
  gulp.watch(paths.coffee, ['coffee'])
});
