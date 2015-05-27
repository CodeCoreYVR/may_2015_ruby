# Cohort 8: 'nix CLI and Git
## Getting Started with Git
_note_: To view a markdown preview in atom, use `ctrl-shift-m`

Git is a powerful distributed version source control system. Just like google docs has revision history, git keeps track of who changed what, and _hopefully_ why.  

Let's make a new directory and add a README markdown file to it.
```
mkdir cohort_8
cd cohort_8
touch README.md
```
Add some markdown to the README file.
```
# Cohort_8 Day 1
```
Now, let's initialize a git repository.
```
git init
ls -a
```
`git init` initializes a hidden git repository that keeps track of any changes in your working directory, that you add.

If you type `git status` you can see the 'tracked' and 'untracked' files.
```
$ git status
On branch master

Initial commit

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	README.md
```
Add files to keep track of with `git add`. In this case, we can either add all files with `git add -A`, or we can explicitly add only the README file with `git add README.md`

Now, let's make a commit. To make a commit, we can either just type `git commit` which will open up a text editor for us to use to make a commit message (vim by default), or we can include the message in our commit command with `git commit -m "<some-message>"`

## Getting Started with 'Nix commands
1.) How do you list all the dotfiles in your home directory?
`ls ~/.` will list all the files in your home directory that begin with a `.`

Let's open up our `~/.bash_profile` file and add some bash code to use the `~/.bashrc` as your bash configuration file.  
```
if [ -f ~/.bashrc ]; then
  source ~/.bashrc;
fi
```
You can then add all your aliases, or other bash configurations into your `/.bashrc` file. For example, I like to add color to my `ls` command with this alias `alias ls="ls -G"`

## Branching, Merging, and Conflicts
[Google HTML & CSS Styleguide](http://google-styleguide.googlecode.com/svn/trunk/htmlcssguide.xml) | [Chrome DevTools](http://discover-devtools.codeschool.com/)

Let's create a new directory called `branching_merging_conflicts`, and add an index.html file to it.
```
mkdir branching_merging_conflicts
cd branching_merging_conflicts
touch index.html
```
Now, let's add some contents to our index page
```html
<!DOCTYPE html>

<meta charset="UTF-8">
<title>My Super Awesome Website!</title>

<h1>Welcome to My Site!</h1>
<p>This is my awesome site</p>
```
Initialize a git repository with `git init`, add the index file to your git stage, and make an initial commit `git add index.html`, `git commit -m "Add index page"`

### Branching
Create a new branch to add styles. Then checkout that branch, and run `git branch` to make sure you are actually on the new branch.
```
git branch add-styles
git checkout add-styles
git branch
```
Make a directory called stylesheets inside another directory that you also make called assets. Bonus: Make these directories with one command!
```
mkdir -p assets/stylesheets
```
Now, let's add a css file for the styles, and some styles to make the background of our webpage black, and the text white.
```
touch assets/stylesheets/styles.css
```
```CSS
/* assets/stylesheets/styles.css */
body {
  background-color: #000000;
  color: #ffffff;
}
```
Make sure to add a link on your index page to your stylesheet.
```
<link rel="stylesheet" href="assets/stylesheets/styles.css">
```
Add the changes to your git staging, and create a commit.
```
git add -a
git commit -m "Add stylesheet and styles"
```
Now if we checkout our master branch, we will see it is different from our `add-styles` branch. We can merge in the changes, but for now, let's just checkout a new branch called `add-scripts`

```
git checkout -b add-scripts
```
Create a directory in your assets directory for javascripts called scripts and a file called script.js.
```
mkdir -p assets/scripts
touch assets/scripts/script.js
```
TO BE CONTINUED!
