/**
 * This file uses the Page Object pattern to define the main page for tests
 * https://docs.google.com/presentation/d/1B6manhG0zEXkC-H-tPo2vwU06JhL8w9-XCF9oehXzAQ
 */

'use strict';

var MainPage = function() {
  this.h2El = element(by.css('h2'));
  this.signUp = element(by.linkText("Sign Up"));
  this.usernameInput = element(by.model('user.email'));
  this.passwordInput = element(by.model('user.password'));
  this.error = element(by.binding("error"));
  this.loginButton = element(by.buttonText('Login'));

  this.setUsername = function(username) {
    this.usernameInput.sendKeys(username);
  }

  this.setPassword = function(password) {
    this.passwordInput.sendKeys(password);
  }

  this.getError = function() {
    return this.error.getText();
  }
};

module.exports = new MainPage();
