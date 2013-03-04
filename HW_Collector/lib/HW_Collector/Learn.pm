package HW_Collector::Learn;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw(b64_encode b64_decode);
use utf8;
use Encode;


# トップページレンダリング
sub top{
    my $self = shift;
    $self->render();
}


# 文字登録
sub character_learning{

    my $self = shift;

    my $json = Mojo::JSON->new;
    my $data_hash;

    ### データを格納
    my $input_key = &load_param_key; # 受理するデータのkey定義

    # デフォルトではデータ一つづつの学習を前提としたインターフェイス。
    # load_param_keyのパラメータを改造することで、複数同時に学習することも可能。
    foreach my $key (keys %$input_key){
	my @tmp_list = @{$input_key->{$key}};
	for(my $k = 0; $k <= $#tmp_list; $k++){
	    if(defined($self->param($tmp_list[$k]))){
		$data_hash->{$key}->[$k] = $json->decode($self->param($tmp_list[$k]));
	    }
	}
    }

    ### キャンバスサイズ設定 デフォルト
    my $canv_w = 150;
    my $canv_h = 150;
    if(defined($self->param('width'))){
	$canv_w = $self->param('width');
    }
    if(defined($self->param('height'))){
	$canv_h = $self->param('height');
    }

    # デフォルトの学習結果格納ファイル
    my $learn_data_file = 'learn_default.s';

    if(defined($self->param('category'))){

	if($self->param('category') eq '1'){
	    $learn_data_file = 'learn_arabic_numeric.s';
	}elsif($self->param('category') eq '2'){
	    $learn_data_file = 'learn_alphabet.s';
	}elsif($self->param('category') eq '3'){
	    $learn_data_file = 'learn_katakana.s';
	}elsif($self->param('category') eq '4'){
	    $learn_data_file = 'learn_hiragana.s';
	}elsif($self->param('category') eq '5'){
	    $learn_data_file = 'learn_symbols.s';
	}
    }

    # 学習させたい文字の定義
    my $value = '';
    if(defined($self->param('value'))){
	$value = $self->param('value');
    }else{
	$value = '';
    }
    if($value eq ''){
	$self->render_text('no value! Please define character.');
    }else{

	### S式への変換処理
	foreach my $key (keys %$data_hash){
	    my @tmp_list = @{$data_hash->{$key}};
	    for(my $k=0; $k <= $#tmp_list; $k++){
		my @lines = @{$tmp_list[$k]->{'lines'}};
		my $strokes='';
		for(my $k=0;$k<=$#lines; $k++){
		    my $strokes_temp = '(';
		    my @lines2 = @{$lines[$k]};
		    for(my $k2=0;$k2<=$#lines2; $k2++){
			my @cord = @{$lines2[$k2]};
			$strokes_temp .= '('.$cord[0].' '.$cord[1].')';
		    }
		    $strokes_temp .= ')';
		    $strokes .= $strokes_temp;
		}
		$strokes .= '';
		my $s_formula = '(character (value '.$value.")(width $canv_w)(height $canv_h)(strokes $strokes)".')'."\n";
		if($strokes eq ''){
		    $s_formula = 'ENPTY';
		}
		
		### S式の保存
		if($s_formula ne 'ENPTY'){
		    $self->app->model->file_create_append('learned/'.$learn_data_file,$s_formula);
		}
	    }
	}


	$self->render_text('learned: '.$self->param('value'));

    }
    
}


# 受け取りパラメータ名設定
# 効率的に、複数同時に学習する際にパラメータ名を追加可能

sub load_param_key{
    
    my @char = (
	'data1'
	);
    
    my $hash = {
	'char' => \@char
    };
    
    return($hash);
}


1;
