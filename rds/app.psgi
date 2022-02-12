use DBI;
use 5.34.0;
use feature qw(try);
no warnings "experimental::try";

my $database = $ENV{MYSQL_DATABASE};
my $host = $ENV{MYSQL_HOST};
my $port = $ENV{MYSQL_PORT};
my $user = $ENV{MYSQL_USER};
my $password = $ENV{MYSQL_PASSWORD};

# initialize the database
try {
    my $dbh = DBI->connect(
        "DBI:mysql:;host=$host;port=$port",
        $user, $password,
        {'RaiseError' => 1});
    $dbh->do("CREATE DATABASE IF NOT EXISTS `$database`");
    $dbh->do("CREATE TABLE IF NOT EXISTS `$database`.`access_count` (`id` INT PRIMARY KEY, `number` BIGINT)");
    $dbh->disconnect();
} catch ($e) {
    say STDERR $e;
}

my $app = sub {
    my $dbh = DBI->connect(
        "DBI:mysql:database=$database;host=$host;port=$port",
        $user, $password,
        {'RaiseError' => 1});

    # begin a transaction
    $dbh->{AutoCommit} = 0;

    # fetch the access count
    my $sth = $dbh->prepare("SELECT * FROM `access_count` WHERE `id` = 1 FOR UPDATE");
    $sth->execute();
    my $row = $sth->fetchrow_hashref();

    my $number = 0;
    if ($row) {
        # increment
        $number = $row->{number};
        $number++;
        $dbh->do("UPDATE `access_count` SET `number` = ?", undef, $number);
    } else {
        # create a new row
        $number++;
        $dbh->do("INSERT INTO `access_count` (`id`, `number`) VALUES (?, ?)", undef, 1, $number);
    }

    # commit
    $dbh->{AutoCommit} = 1;
    $dbh->disconnect();
    return [200, ['Content-Type' => 'text/plain'], ["$number\n"]];
};
