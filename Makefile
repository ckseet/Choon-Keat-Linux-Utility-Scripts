all:
	@echo "NO"
webdev:
	sudo rm -rf  /var/www/html/*
	sudo cp -rpv html/*  /var/www/html/
deploy:
	rm ~/public_html/*.shtml
	rm ~/public_html/*.php
	rm ~/public_html/favicon.ico
	rm ~/public_html/default.html
        # rm ~/public_html/cgi-bin/*
	cp -rpv html/* ~/public_html/
        chmod 444 ~/public_html/*.shtml
	chmod 444 ~/public_html/*.php
	chmod 444 ~/public_html/*.html
	chmod 444 ~/public_html/.htaccess
        # chmod 555 ~/public_html/cgi-bin
