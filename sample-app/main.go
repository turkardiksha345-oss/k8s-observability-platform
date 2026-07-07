package main

import (
    "fmt"
    "log"
    "net/http"
    "os"
    "strconv"
    "sync/atomic"
    "time"

    "github.com/prometheus/client_golang/prometheus"
    "github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
    requestCounter = prometheus.NewCounterVec(
        prometheus.CounterOpts{
            Name: "http_requests_total",
            Help: "Total number of HTTP requests",
        },
        []string{"path", "status"},
    )
    requestDuration = prometheus.NewHistogramVec(
        prometheus.HistogramOpts{
            Name: "http_request_duration_seconds",
            Help: "HTTP request duration in seconds",
            Buckets: prometheus.DefBuckets,
        },
        []string{"path"},
    )
    activeRequests atomic.Int64
    errorsTotal = prometheus.NewCounter(prometheus.CounterOpts{
        Name: "http_errors_total",
        Help: "Total number of HTTP errors",
    })
)

func init() {
    prometheus.MustRegister(requestCounter, requestDuration, errorsTotal)
}

func main() {
    mux := http.NewServeMux()
    mux.HandleFunc("/", handleRoot)
    mux.HandleFunc("/health", handleHealth)
    mux.Handle("/metrics", promhttp.Handler())

    port := os.Getenv("PORT")
    if port == "" {
        port = "8080"
    }

    srv := &http.Server{Addr: ":" + port, Handler: mux, ReadHeaderTimeout: 5 * time.Second}
    log.Printf("sample app listening on :%s", port)
    log.Fatal(srv.ListenAndServe())
}

func handleRoot(w http.ResponseWriter, r *http.Request) {
    start := time.Now()
    activeRequests.Add(1)
    defer func() {
        activeRequests.Add(-1)
        requestDuration.WithLabelValues(r.URL.Path).Observe(time.Since(start).Seconds())
    }()

    if r.URL.Query().Get("fail") == "1" {
        errorsTotal.Inc()
        http.Error(w, "simulated failure", http.StatusInternalServerError)
        requestCounter.WithLabelValues(r.URL.Path, strconv.Itoa(http.StatusInternalServerError)).Inc()
        return
    }

    fmt.Fprintf(w, "sample app ok\n")
    requestCounter.WithLabelValues(r.URL.Path, strconv.Itoa(http.StatusOK)).Inc()
}

func handleHealth(w http.ResponseWriter, r *http.Request) {
    requestCounter.WithLabelValues("/health", strconv.Itoa(http.StatusOK)).Inc()
    fmt.Fprintf(w, "ok\n")
}
