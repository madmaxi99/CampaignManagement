<?php

declare(strict_types=1);

/**
 * Prints the .env line for the DM password.
 *
 *   php backend/bin/hash-dm-password.php 'mein geheimes passwort'
 *   (or without argument: the password is read from stdin)
 *
 * The "$" of the hash are doubled because docker compose interpolates "$" in
 * env files.
 */
$password = $argv[1] ?? trim((string) fgets(STDIN));
if ($password === '') {
    fwrite(STDERR, "Kein Passwort angegeben.\n");
    exit(1);
}

echo 'DM_PASSWORD_HASH=' . str_replace('$', '$$', password_hash($password, PASSWORD_DEFAULT)) . "\n";
