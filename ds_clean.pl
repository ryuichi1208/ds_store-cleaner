#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;
use Data::Dumper;
use File::Find;
use File::stat;

sub get_dir {
    my $dir = shift;
    my @list = ();
    my @dot_list = ();

    opendir(DIR, $dir) or die("Can't open directory: $dir");
    @list = readdir(DIR);
    closedir(DIR);

    foreach my $file (sort @list) {
        next if( $file =~ /^\.{1,2}$/ );

        if (-d "$dir/$file") {
            get_dir("$dir/$file");
        }
        elsif (-f "$dir/$file" && "$dir/$file" =~ /.ds_store/) {
            print "$dir/$file\n";
            push(@dot_list, "$dir/$file");
        }
        else {
            next
        }
    }
    foreach(@dot_list){
        unlink $_ or warn "Clound not unlink $_: $!";
    }
}

sub main {
    my @argv = @_;
    my $directory_to_be_deleted = ".";

    if ($argv[0]) {
        $directory_to_be_deleted = $argv[0];
    }

    get_dir('.');
}

main(@ARGV)
