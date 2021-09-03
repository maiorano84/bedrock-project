vcl 4.0;

backend default {
    .host = "{{ .Values.backend.host | default (print .Release.Name "-http") }}";
    .port = "{{ .Values.backend.port | default "8080" }}";
}

acl purge {
{{- range .Values.purgeWhitelist }}
    {{- . | quote | nindent 4 }};
{{- end }}
}

sub vcl_recv {
  if (req.method == "PURGE") {
    if (!client.ip ~ purge) {
      return(synth(405,"Not allowed."));
    }
    return (purge);
  }
  if (req.http.Accept-Encoding) {
    if (req.url ~ "\.(gif|jpg|jpeg|swf|flv|mp3|mp4|pdf|ico|png|gz|tgz|bz2)(\?.*|)$") {
      unset req.http.Accept-Encoding;
    } elsif (req.http.Accept-Encoding ~ "gzip") {
      set req.http.Accept-Encoding = "gzip";
    } elsif (req.http.Accept-Encoding ~ "deflate") {
      set req.http.Accept-Encoding = "deflate";
    } else {
      unset req.http.Accept-Encoding;
    }
  }
  if (req.url ~ "\.(gif|jpg|jpeg|swf|css|js|flv|mp3|mp4|pdf|ico|png)(\?.*|)$") {
    unset req.http.cookie;
    set req.url = regsub(req.url, "\?.*$", "");
  }
  if (req.url ~ "\?(utm_(campaign|medium|source|term)|adParams|client|cx|eid|fbid|feed|ref(id|src)?|v(er|iew))=") {
    set req.url = regsub(req.url, "\?.*$", "");
  }
  if (req.http.cookie) {
    if (req.http.cookie ~ "(wordpress_|wp-settings-)") {
      return(pass);
    } else {
      unset req.http.cookie;
    }
  }
}

sub vcl_backend_response {
  if (bereq.url ~ "wp-(login|admin)" || bereq.url ~ "preview=true" || bereq.url ~ "xmlrpc.php") {
    set beresp.uncacheable = true;
    set beresp.ttl = 120s;
    return (deliver);
  }
  if ( (!(bereq.url ~ "(wp-(login|admin)|login)")) || (bereq.method == "GET") ) {
    unset beresp.http.set-cookie;
  }
  if (bereq.url ~ "\.(gif|jpg|jpeg|swf|css|js|flv|mp3|mp4|pdf|ico|png)(\?.*|)$") {
    set beresp.ttl = 365d;
  }
}

sub vcl_deliver {
   if (obj.hits > 0) {
     set resp.http.X-Cache = "HIT";
   } else {
     set resp.http.X-Cache = "MISS";
   }
}
