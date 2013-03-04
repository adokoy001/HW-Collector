package HW_Collector::Model;

use Mojo::Base 'Mojolicious';
use Mojo::Home;

use utf8;
use Encode;

use File::Spec::Functions 'catfile';
use File::Basename;



### モデルのコンフィグ

__PACKAGE__->attr(datadir => 'data'); # データ格納用ディレクトリ

### データファイル読み込み
sub datafile {
    my $self = shift;
    my $id = shift;
    return catfile($self->datadir, $id);
}

### ファイル作成追記型
sub file_create_append{

    my $self = shift;
    my $id = shift;
    my $data = shift;
    $data = Encode::decode('utf8',$data);
    open my $fh, '>>', $self->datafile($id) or return;
    print $fh $data;
    return 1;

}

1;
