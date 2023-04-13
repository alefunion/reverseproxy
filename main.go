package main

import (
	"bufio"
	"fmt"
	"log"
	"net/http"
	"net/http/httputil"
	"os"
	"strings"
	"time"
)

func spaceOrTab(r rune) bool {
	return r == ' ' || r == '\t'
}

// Origin hosts mapped to target hosts
var hostmap = make(map[string]string)

func init() {
	// Help
	if len(os.Args) > 1 && (os.Args[1] == "-h" || os.Args[1] == "-help" || os.Args[1] == "help") {
		print(`Alef Union Reverse Proxy

Usage:

	Create an /etc/reverseproxy/hostmap file containing host mapping (origin to target, 1 per line).
	Example:
		alefunion.com		localhost:8000
		api.alefunion.com	localhost:8001

`)
		os.Exit(0)
	}

	// Make hostmap
	f, err := os.Open("/etc/reverseproxy/hostmap")
	if err != nil {
		fmt.Println("hostmap file not found")
		os.Exit(1)
	}
	defer f.Close()

	s := bufio.NewScanner(f)
	for s.Scan() {
		l := s.Text()
		fields := strings.FieldsFunc(l, spaceOrTab)
		if len(fields) != 2 {
			fmt.Printf("hostmap must have 2 fields per line (origin and target), not %d: %q\n", len(fields), l)
			os.Exit(1)
		}
		hostmap[fields[0]] = fields[1]
	}
}

func main() {
	proxy := &httputil.ReverseProxy{Director: func(r *http.Request) {
		target := hostmap[r.Host]
		r.URL.Scheme = "http"
		r.URL.Host = target
	}}

	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if _, ok := hostmap[r.Host]; !ok {
			http.Redirect(w, r, "https://www.alefunion.com", http.StatusTemporaryRedirect)
			return
		}
		proxy.ServeHTTP(w, r)
	})

	log.Fatalln(http.ListenAndServe(":80", http.TimeoutHandler(handler, 1*time.Hour, "")))
}
