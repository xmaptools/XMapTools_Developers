<?php
/**
 * XMapTools – Lightweight anonymous download/update counter
 *
 * Accepts GET requests with the following parameters:
 *   action  = install | update | info   (required)
 *   arch    = Intel | AppleSilicon | Windows  (required)
 *   os      = macOS | Windows           (optional)
 *   v       = script version string     (optional)
 *
 * Logs one line per event to a TSV file.  No IP addresses, no cookies,
 * no personally-identifiable information is stored.
 *
 * Endpoint: https://xmaptools.ch/api/count.php
 * Deploy:   place this file in <webroot>/api/count.php
 *           create <webroot>/api/data/ and make it writable by the web user
 *           (e.g. www-data).  The .htaccess in this directory denies direct
 *           HTTP access to the data/ folder.
 */

// ---------- Configuration ---------------------------------------------------

// Where the TSV log file is stored (outside the web root is even better)
define('DATA_DIR', __DIR__ . '/data');
define('LOG_FILE', DATA_DIR . '/xmaptools_stats.tsv');

// Rate-limit: max events per IP within the window (simple in-memory check
// is skipped; rely on web-server rate-limiting for production).

// Allowed values for each parameter (whitelist)
$ALLOWED_ACTIONS = ['install', 'update', 'info'];
$ALLOWED_ARCHS   = ['Intel', 'AppleSilicon', 'Windows'];
$ALLOWED_OS      = ['macOS', 'Windows'];

// ---------- Ensure data directory exists ------------------------------------

if (!is_dir(DATA_DIR)) {
    mkdir(DATA_DIR, 0750, true);
}

// ---------- Read & sanitise parameters --------------------------------------

$action = $_GET['action'] ?? '';
$arch   = $_GET['arch']   ?? '';
$os     = $_GET['os']     ?? '';
$ver    = $_GET['v']      ?? '';

// Validate against whitelists
if (!in_array($action, $ALLOWED_ACTIONS, true)) {
    http_response_code(400);
    exit('Bad request: invalid action');
}
if (!in_array($arch, $ALLOWED_ARCHS, true)) {
    http_response_code(400);
    exit('Bad request: invalid arch');
}
if ($os !== '' && !in_array($os, $ALLOWED_OS, true)) {
    $os = 'unknown';
}

// Strip anything unexpected from the version string
$ver = preg_replace('/[^0-9.]/', '', $ver);

// ---------- Write log line --------------------------------------------------

$timestamp = gmdate('Y-m-d\TH:i:s\Z');
$line = implode("\t", [$timestamp, $action, $arch, $os, $ver]) . "\n";

$ok = file_put_contents(LOG_FILE, $line, FILE_APPEND | LOCK_EX);

if ($ok === false) {
    http_response_code(500);
    exit('Internal error');
}

// ---------- Respond with 204 No Content (nothing to return) -----------------

http_response_code(204);
exit;
