package HW_Collector;
use Mojo::Base 'Mojolicious';

use utf8;
use Encode;

use File::Spec::Functions 'catfile';

use HW_Collector::Model;
use HW_Collector::myTimeUtil;

### attr config

__PACKAGE__->attr(datadir => 'data');


### $self->app->で呼び出せるように設定
__PACKAGE__->attr(model => sub { HW_Collector::Model->new });
__PACKAGE__->attr(tutl => sub { HW_Collector::myTimeUtil->new });




# This method will run once at server start
sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');

  # Router
  my $r = $self->routes;

  $self->model->datadir($self->home->rel_dir('/lib/data'));


  # 文字学習トップ
  $r->get('/learn_top')->to('Learn#top');

  # 学習データ送信
  $r->post('/char_learn')->to('Learn#character_learning');

}

1;
