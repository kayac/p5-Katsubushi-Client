requires 'perl', '5.008001';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::TCP';
};

requires 'Class::Tiny';
requires 'Cache::Memcached::Fast';
requires 'version', '0.77';
