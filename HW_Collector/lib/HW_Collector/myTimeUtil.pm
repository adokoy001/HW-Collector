package HW_Collector::myTimeUtil;

use Mojo::Base 'Mojolicious';
use Mojo::Home;

use utf8;
use Encode;

use Time::HiRes;
use Time::Local;


# 現在日時をフォーマット付きで取得
sub get_timestamp_str{
    my $self = shift;
    my $times = &get_timestamp_array;
    my $output_str = sprintf("%04d-%02d-%02d %02d:%02d:%02d",
			     $times->[5],
			     $times->[4],
			     $times->[3],
			     $times->[2],
			     $times->[1],
			     $times->[0]
	);
    return($output_str);
}

# 本日の日付をフォーマット付きで取得
sub get_date_str{
    my $self = shift;
    my $times = &get_timestamp_array;
    my $output_str = sprintf("%04d-%02d-%02d",
			     $times->[5],
			     $times->[4],
			     $times->[3]
	);
    return($output_str);
}

# 現在日時をリストリファレンスで取得
sub get_timestamp_array{
    my ($sec,$min,$hour,$day,$month,$year) = (localtime(time))[0,1,2,3,4,5];
    $year += 1900;
    $month++;
    my $time_array = [$sec,$min,$hour,$day,$month,$year];
    return($time_array);
}

1;
