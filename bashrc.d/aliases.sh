emailhtmldecode() {
    qpdecode "$(urldecode "$1")"
}

# shellcheck disable=1004
# (\ in '')
alias urldecode='python3 -c "import sys, urllib.parse as u; \
    print(u.unquote_plus(sys.argv[1]))"'

# shellcheck disable=1004
alias urlencode='python3 -c "import sys, urllib.parse as u; \
    print(u.quote_plus(sys.argv[1]))"'

# shellcheck disable=1004
alias qpdecode='python3 -c "import sys, quopri; \
    print(quopri.decodestring(sys.argv[1]).decode(\"utf-8\"))"'
