<?php

function getRedis($host, $port) {
    $obj_r = new Redis();
    $obj_r->connect($host, $port);
    return $obj_r;
}

$opt = getopt('n:h:p:');
$host = $opt['h'] ?? '127.0.0.1';
$port = $opt['p'] ?? 6379;
$n = $opt['n'] ?? 1;

/* Bad auth */
for ($i = 0; $i < $n; $i++) {
    try {
        $obj_r = getRedis($host, $port);
        $obj_r->auth('foo', 'bar');
        $obj_r->set("key:$i", "val:$i");
        echo "[$i]: GET: " . $obj_r->get("key:$i") . "\n";
    } catch (Exception $ex) {
        echo "[$i] Exception: " . $ex->getMessage() . "\n";
    }
}

/* Good auth */
for ($i = 0; $i < $n; $i++) {
    try {
        $obj_r = getRedis($host, $port);
        $obj_r->auth(['admin', 'admin']);
        $obj_r->set("key:$i", "val:$i");
        echo "[$i]: GET: " . $obj_r->get("key:$i") . "\n";
    } catch (Exception $ex) {
        echo "[$i] Exception: " . $ex->getMessage() . "\n";
    }
}
