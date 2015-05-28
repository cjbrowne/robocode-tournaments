'use strict';

var watchify = require('watchify');
var browserify = require('browserify');
var gulp = require('gulp');
var source = require('vinyl-source-stream');
var buffer = require('vinyl-buffer');
var gutil = require('gulp-util');
var sourcemaps = require('gulp-sourcemaps');
var assign = require('lodash.assign');
var sass = require('gulp-sass');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');

// add custom browserify options here
var customOpts = {
  entries: ['./src/main.js'],
  // TODO: set to false for prod (HOW?)
  debug: true
};
var opts = assign({}, watchify.args, customOpts);
var b = browserify(opts);

// add transformations here
// i.e. b.transform(coffeeify);

gulp.task('bundle', bundle); // so you can run `gulp js` to build the file
gulp.task('deploy', ['bundle'], deploy);


gulp.task('sass', function () {
	console.log('rebuilt sass');
	gulp.src(['./sass/**/*.scss', './sass/*.scss'])
	    .pipe(sass().on('error', sass.logError))
	    .pipe(concat('robotorn.css'))
	    .pipe(gulp.dest('./css'));
});

gulp.task('watch-js', function () {
	gulp.watch(['./src/**/*.js', './src/*.js'], ['bundle']);
})

gulp.task('watch-sass', function () {
	gulp.watch(['./sass/**/*.scss', './sass/*.scss'], ['sass']);
});

gulp.task('default', ['watch-js', 'watch-sass', 'sass', 'bundle']);

function bundle() {
	return b.bundle()
		// log errors if they happen
		.on('error', gutil.log.bind(gutil, 'Browserify Error'))
		.pipe(source('robocode-tournament.js'))
		// optional, remove if you don't need to buffer file contents
		.pipe(buffer())
		// optional, remove if you dont want sourcemaps
		.pipe(sourcemaps.init({loadMaps: true})) // loads map from browserify file
		   // Add transformation tasks to the pipeline here.
		.pipe(sourcemaps.write('./')) // writes .map file
		.pipe(gulp.dest('./js/'));
}

function deploy() {
	// html
	gulp.src('./index.html')
		.pipe(gulp.dest('./deploy/'));
	
	// templates
	gulp.src('./templates/*.html')
		.pipe(gulp.dest('./deploy/templates/'));

	gulp.src('./js/robocode-tournament.js')
		.pipe(uglify())
		.pipe(gulp.dest('./deploy/js/'));

	gulp.src('./css/robotorn.css')
		.pipe(gulp.dest('./deploy/css/'));
}