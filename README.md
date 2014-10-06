# Noted

Noted is a note-taking application along the lines of tomboy.

It is web based and has a focus on simplicity in code and in UX.

The core premise is that notes can easily link to one another, forming a web.

To create a link to another note, surround it in double square brackets like:

`[[this]]`

To start writing in that note, just click the link.

To create a new note without linking to it, or navigate to a note, type it's name in either the title field or the address bar.

You can check out a [demo](http://noted-demo.davidbanham.com/) if you like.

### Running your own

To run the server:

`node server.js`

The server looks for three environment variables, all optional.

* PORT - Default 3000
* NOTEDIR - Default ./notes
* NOTEDPASS - Defaults to not being required

If a password is set, all requests will be served with a login page. Enter the password and blur the input element, you'll be redirected.

There are no dependencies, there are no libraries. Have fun!
