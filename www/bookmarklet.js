var hasLogin = function() {
	return location.hash.search(/bpiUsername=(.+)&/g) > -1;
}

var getUsernameFromHash = function() {
	return decodeURIComponent(/bpiUsername=(.+)&/g.exec(location.hash)[1]);
}

var getPasswordFromHash = function() {
	return decodeURIComponent(/bpiPassword=(.+)&?/g.exec(location.hash)[1]);
}

var fillLogin = function(username, password) {
	document.querySelector('input[type=email]').value = username;
	document.querySelector('input[type=password]').value =  password;
	document.querySelector('input[type=submit], button[type=submit]').click();
}

if (!hasLogin()) {
	location.href = "bpi://fillWebForm/" +  encodeURIComponent(location.href);
} else {
	var username = getUsernameFromHash();
	var password = getPasswordFromHash();
	fillLogin(username, password);
}