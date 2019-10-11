#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;
use Data::Dumper;
use File::Find;
use File::stat;

my $TIMEOUT = $ENV{TIMEOVER} || 300;

sub print_usage {
    print "Usage: $0 [Directory]";
    exit(1);
}

sub get_dir_and_unlink {
    my $dir = shift;
    my @list = ();
    my @dot_list = ();

    # Open the passed argument directory.
    opendir(DIR, $dir) or die("Can't open directory: $dir");
    @list = readdir(DIR);
    closedir(DIR);

    # Search the target file by recursively digging the directory.
    foreach my $file (sort @list) {
        next if( $file =~ /^\.{1,2}$/ );

        if (-d "$dir/$file") {
            get_dir_and_unlink("$dir/$file");
        }
        elsif (-f "$dir/$file" && "$dir/$file" =~ /.DS_store/) {
            print "$dir/$file\n";
            push(@dot_list, "$dir/$file");
        }
        else {
            next
        }
    }
    # Delete the target file.
    foreach(@dot_list){
        unlink $_ or warn "Clound not unlink $_: $!";
    }
}

sub main {
    my @argv = @_;
    my $directory_to_be_deleted = ".";


    if ($argv[0]) {
        $directory_to_be_deleted = $argv[0];
        stat($directory_to_be_deleted) or die $!;
    } elsif (@argv >= 2) {
        print_usage;
    }

    print localtime, " : START\n";
    get_dir_and_unlink($directory_to_be_deleted);
    print localtime, " : END\n";
}

main(@ARGV)

__END__
