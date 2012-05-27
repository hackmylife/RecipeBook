package RecipeBook::Parser::Cookpad;

use strict;
use Web::Scraper::LibXML;
#use Web::Scraper;
use URI;
use Encode qw//;
use Data::Dumper;
use LWP::UserAgent;

HTML::TreeBuilder::LibXML->replace_original();

sub parse {
    my ($self, $uri) = @_;
    my $recipe = scraper {
        process ".recipe-title", title => "TEXT";
        process "#main-photo img", image => '@src';
        process "#description", description => "TEXT";
        process ".ingredient_row", "ingredients[]" => scraper {
            process ".ingredient_category", category => "TEXT",
            process ".ingredient_name", name => "TEXT",
            process ".ingredient_quantity", quantity => "TEXT",
        }
    };

    my $ua = LWP::UserAgent->new;
    my $response = $ua->get($uri);
    my $html = $response->decoded_content;
    $html =~ s!</html>.*!</html>!s;
    my $res = $recipe->scrape( \$html );

    my @ingredients;
    foreach my $item (@{$res->{ingredients}}) {
        push @ingredients, {
            category => _trim_space( $item->{category}) || '',
            name => _trim_space( $item->{name}) || '',
            quantity => _trim_space( $item->{quantity}) || '',
        }
    };

    return +{
        title => _trim_space( $res->{title}),
        uri   => $uri,
        image => $res->{image},
        description => _trim_space( $res->{description} ),
        ingredients => \@ingredients,
    }

}

sub _trim_space {
    my $str = shift;
    $str =~ s/^\s*//g;
    $str =~ s/\s*$//g;
    $str =~ s/\n//g;
    $str =~ s/\s+/ /g;
    return $str;
}

1;
__DATA__
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

  <html xmlns:fb="http://ogp.me/ns/fb#">

  <head prefix="og: http://ogp.me/ns# cookpad: http://ogp.me/ns/apps/cookpad#">
    <script type="text/javascript">var __rendering_time = (new Date).getTime();</script>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta content='175180302552476' property='fb:app_id'>
<meta content='cookpad:recipe' property='og:type'>
<meta content='酸辣湯（すっぱ辛い中華スープ） by お気楽主婦' property='og:title'>
<meta content='我が家の好評メニューです。&#x000A;暑い夏にも良いけれど、寒い季節にも最高♪&#x000A;2008.8.19、分量を少々見直しました。' property='og:description'>
<meta content='http://d3921.cpcdn.com/recipes/117485/120x120c/adb3594d9c0f636e68a1be05f16e3544.jpg?u=36109&amp;p=1219145947' property='og:image'>
<meta content='http://cookpad.com/recipe/117485' property='og:url'>


    <link rel="alternate" media="handheld" type="text/html" href="http://m.cookpad.com/recipe/show/117485" />
    <link rel="apple-touch-icon" href="/images/device/apple-touch-icon.png" />

    <title>酸辣湯（すっぱ辛い中華スープ） by お気楽主婦 [クックパッド] 簡単おいしいみんなのレシピが122万品</title><meta content="酸辣湯（すっぱ辛い中華スープ）,竹の子水煮（細切り）,椎茸,にんじん,絹ごし豆腐,豚バラスライス,水,顆粒鶏がらスープ,卵,万能ねぎor三つ葉,～調味料～,★醤油,★塩,★こしょう,★ラー油,水溶き片栗粉,●酢,レシピ,簡単,料理,COOKPAD,くっくぱっど,recipe" name="keywords" /><meta content="我が家の好評メニューです。暑い夏にも良いけれど、寒い季節にも最高♪2008.8.19、分量を少々見直しました。" name="description" />

    

    

    <script src="/javascripts/jpack.js?1337932029" type="text/javascript"></script>


    <script type="text/javascript"></script>

    
    
<script type="text/javascript">
//<![CDATA[
var __load_url = "/loading/all_in_one";
var __load_parameters = "a=show&ad=110%2C111%2C112%2C104%2C500%2C122%2C511%2C307%2C508%2C512%2C507%2C506&c=recipe&id=117485&kuid=36109&ltp=1&myfolder_recipe_117485_bottom=1&myfolder_recipe_117485_top=1&qs=&sponsored_trend_keywords=1&status=1&trend_keyword_hourly=1&trend_keywords_header=1&welcome=1&referer="+encodeURIComponent(window.__override_referrer||document.referrer);
var __replace_table = {"ad": [{"div_id": "500_panel", "id": 110}, {"div_id": "300_panel", "id": 111}, {"div_id": "150_panel", "id": 112}, {"div_id": "search_banner", "id": 104}, {"div_id": "cook_tv_banner", "id": 500}, {"div_id": "selected_user_ad", "id": 122}, {"div_id": "tieup_list_content", "id": 511}, {"div_id": "introduce_enquete", "id": 307}, {"div_id": "ad_right_down_image", "id": 508}, {"div_id": "ad_right_down_text", "id": 512}, {"div_id": "footer_txt_banner", "id": 507}, {"div_id": "cpc_footer_banner", "id": 506}], "ltp": "1", "myfolder_recipe_117485_bottom": "1", "myfolder_recipe_117485_top": "1", "sponsored_trend_keywords": "1", "status": "1", "trend_keyword_hourly": "1", "trend_keywords_header": "1", "welcome": "1"};
var __newloading = {assigns: "{\"from_search_engine_ext\":{\"id_param\":\"117485\"},\"staff_footer\":{}}", specify:["from_search_engine_ext","staff_footer"]};
__load_parameters += '&' + jQuery.param(__newloading);

(function(){
if (!window.jQuery) return;
var count = 0;
if (window.__rendering_time) {
  var lt = new Date().getTime() - window.__rendering_time;
  if (lt > 5000) lt = 5000;
  if (lt < 1) lt = 1;
  __load_parameters += '&lt=' + lt;
}
jQuery.ajax({
    url:__load_url,
    type: 'get',
    data: __load_parameters,
    complete: callback_loading_all,
    beforeSend: function(xhr, settings) {
      xhr.setRequestHeader('accept', 'text/plain, text/html, */*');
    }
});
function callback_loading_all(request) {
  if (request && request.readyState === 4) {
    window.__loading_all_response = request.responseText;
    if (window.replace_tags) {
      replace_tags();
    } else if (count < 2) {
      setTimeout(function(){
        count++;
        callback_loading_all(request);
      }, 200);
    }
    
  }
}
})();

//]]>
</script>


    

    <link href="/stylesheets/layout.css?1337932037" media="all" rel="stylesheet" type="text/css" />
    <link href="/stylesheets/styles.css?1337932039" media="all" rel="stylesheet" type="text/css" />
    <link href="/stylesheets/application.css?1337932033" media="all" rel="stylesheet" type="text/css" />

    <link href="/stylesheets/lightwindow.css?1337932037" media="screen" rel="stylesheet" type="text/css" />
    <link href="/stylesheets/colorbox.css?1337932033" media="all" rel="stylesheet" type="text/css" />

    <link href="/stylesheets/partial/search_detail.css?1337932037" media="all" rel="stylesheet" type="text/css" />
    <link href="/stylesheets/partial/side_ad.css?1337932038" media="all" rel="stylesheet" type="text/css" />
    <link href="/stylesheets/cookpad.css?1337932036" media="all" rel="stylesheet" type="text/css" />

    <link href="/stylesheets/init.css?1337932036" media="all" rel="stylesheet" type="text/css" />
    <link href="/stylesheets/themes/account.css?1337932039" media="all" rel="stylesheet" type="text/css" />
    <link href="/stylesheets/search_autocomplete.css?1337932039" media="all" rel="stylesheet" type="text/css" />
    <link href="/stylesheets/themes/register_pr_modalbox.css?1337932041" media="screen" rel="stylesheet" type="text/css" />


      <link href="/stylesheets/themes/kitchen.css?1337932040" media="all" rel="stylesheet" type="text/css" />
  <link href="/stylesheets/themes/recipe.css?1337932041" media="all" rel="stylesheet" type="text/css" />
  <link href="/stylesheets/themes/terms.css?1337932042" media="all" rel="stylesheet" type="text/css" />
<link href="/stylesheets/partial/tsukurepo_list.css?1337932038" media="all" rel="stylesheet" type="text/css" /><link href="/stylesheets/partial/tsukurepo.css?1337932038" media="all" rel="stylesheet" type="text/css" />

      <script src="/javascripts/jquery.jeditable.js?1331009262" type="text/javascript"></script>
  <script src="/javascripts/edit.js?1327284077" type="text/javascript"></script>
  <script src="/javascripts/ingredient.js?1336718909" type="text/javascript"></script>
  <script src="/javascripts/swfobject.js?1318414278" type="text/javascript"></script>
  <script src="/javascripts/myfolder.js?1335933344" type="text/javascript"></script>



    
    <meta name="csrf-param" content="authenticity_token"/>
<meta name="csrf-token" content="rXv0V9Gnv6z9GTy5W3SO&#47;GMRE8vGLpS3kM2mNDsAfAE="/>
    
<script>
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', "UA-116800-1"]);
  _gaq.push(["_setCustomVar", 1, "UserType_Visitor", "not_registered", 2]);
  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>
<script id='analytics_holder' data-keyword="">
  (function($) {
      _gaq.push(['_trackPageview']);
  })(jQuery);
</script>

  </head>
  <body class="">

  
  
  
  

      

    

    

    <div id="wrapper">
      <div id="container">
        

        
          <div id="header">
            <div id="header-inner">
              <div id="super_banner">
              </div>

              <div id="header-main">
  <div class="header-main-inner">
    <div class="logo" id="page_top" style="position:relative">

        <a href="/" id="page-top"><img alt="クックパッド" src="/images/large_logo.gif?1318414276" /></a>
        </div>

    <div class="search-field" id="global_search_wrapper">
      <div id="global_search_wrapper_container" style="width: 323px;overflow: hidden;margin-left: 33px">
        <span style="font-weight: bold; float: left;">
          レシピ検索No.1
        </span>
        <span class="font11" style="float:right">
          <a href="/search/detail">詳細検索</a> |
          <span id="recipe_history"></span>
          <script type="text/javascript">
//<![CDATA[

            var switch_recipe_history = new SwitchByCookie();
            switch_recipe_history.add({"user_type": ['0']},"<a href=\"/login?rt=%2Frecipe%2Fhistory&amp;type=recipe_history\" class=\"link_to_login\" params=\"dialog_width=350,dialog_height=390,dialog_title=\">最近見たレシピ<\/a>");
            switch_recipe_history.add_default("<a href=\"/recipe/history\">最近見たレシピ<\/a>");
            switch_recipe_history.render("recipe_history");
            
//]]>
</script>
        </span>
      </div>
      <form accept-charset="UTF-8" action="/search/post" method="get"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div>
  <img alt="Mushimegane" onclick="jQuery(&quot;#keyword&quot;).focus()" src="/images/shared/mushimegane.gif?1337652975" style="vertical-align: top;" />
  <input class="search-field" id="keyword" name="keyword" type="text" value="" />
  <input class="submit-search" name="order_by_date" type="submit" value="検索" />
  <div id="popularity_search_button" style="display: inline"></div>



  <script type="text/javascript">
//<![CDATA[

            var popularity_search_button = new SwitchByCookie();
            popularity_search_button.add({"user_type": ['2']}, "<input class=\"submit-search\" name=\"order_by_popularity\" type=\"submit\" value=\"人気検索\" />");
            popularity_search_button.add({"user_type": ['1']}, "<input class=\"submit-search\" onclick=\"        _gaq.push([\'_trackEvent\', \'psEntry\', \'dialogOpen\', \'ヘッダ人気検索ボタン(ログイン)\']);\n          if(confirm(\'人気検索を利用するには、プレミアムサービスの登録が必要です。プレミアムサービスの利用登録をしますか？\')){\nlocation.href=\'https://\'+location.host+\'/user/regist_premium?g=popurality_search\'; return false; }\n;\" type=\"button\" value=\"人気検索\" />");
            popularity_search_button.add({"user_type": ['0']}, "<input class=\"submit-search\" onclick=\"jQuery.colorbox.close();jQuery.colorbox(jQuery.get_login_options(360, 460, \'/login?type=popularity_search\'));;\" type=\"button\" value=\"人気検索\" />");
            popularity_search_button.render("popularity_search_button");
            
//]]>
</script>

</form>      <div style="margin-left: 33px; height: 1.5em;">
        <div id="trend_keyword_hourly"></div>
        
          
            <div id="trend_keywords_header"></div>
      </div>

    </div>
  </div><!--/header-main-inner-->
  
  <div class="my-navi">
    <ul class="list-nav" style="float: left;">
      <li id="list_for_mynews">
      </li>
      <script type="text/javascript">
//<![CDATA[

            var switch_mynews = new SwitchByCookie();
            switch_mynews.add({"user_type": ['0']},"<a href=\"/login?rt=%2Fmynews&amp;type=mynews\" class=\"link_to_login\" id=\"link_to_mynews\" params=\"dialog_width=350,dialog_height=390,dialog_title=\"><img alt=\"MYニュース\" src=\"/images/shared/mynews_wt.gif?1318414276\" /><\/a>");
            switch_mynews.add_default("<a href=\"/mynews\"><img alt=\"MYニュース\" src=\"/images/shared/mynews_wt.gif?1318414276\" /><\/a>");
            switch_mynews.render("list_for_mynews");
            
//]]>
</script>

      <li id="list_for_myfolder">
      </li>
      <script type="text/javascript">
//<![CDATA[

            var switch_myfolder = new SwitchByCookie();
            switch_myfolder.add({"user_type": ['0']},"<a href=\"/login?rt=%2Fmyfolder&amp;type=myfolder\" class=\"link_to_login\" id=\"link_to_myfolder\" params=\"dialog_width=350,dialog_height=390,dialog_title=\"><img alt=\"MYフォルダ\" src=\"/images/shared/myfolder_wt.gif?1318414276\" /><\/a>");
            switch_myfolder.add_default("<a href=\"/myfolder\"><img alt=\"MYフォルダ\" src=\"/images/shared/myfolder_wt.gif?1318414276\" /><\/a>");
            switch_myfolder.render("list_for_myfolder");
            
//]]>
</script>

          <li id="list_for_mykitchen" style="position:relative">
            
            <span id="list_for_mykitchen_link"></span>
          </li>



    <script type="text/javascript">
//<![CDATA[

      var my_kitchen = new SwitchByCookie();
      my_kitchen.add({"user_type": ['2', '1'], has_kitchen: '1'}, "<a href=\"/mykitchen\"><img alt=\"MYキッチン\" src=\"/images/shared/mykitchen_wt.gif?1318414276\" /><\/a>");
      my_kitchen.add({"user_type": ['2', '1'], has_kitchen: '0'}, "<a href=\"/kitchen/regist\" data-confirm=\"MYキッチンをご利用いただくにはMYキッチンの開設が必要です。MYキッチンを開設しますか？\"><img alt=\"MYキッチン\" src=\"/images/shared/mykitchen_wt.gif?1318414276\" /><\/a>");
      my_kitchen.add_default("<a href=\"/login?rt=%2Fmykitchen&amp;type=mykitchen\" class=\"link_to_login\" id=\"link_to_mykitchen\" params=\"dialog_width=350,dialog_height=390,dialog_title=\"><img alt=\"MYキッチン\" src=\"/images/shared/mykitchen_wt.gif?1318414276\" /><\/a>");
      my_kitchen.render("list_for_mykitchen_link");
      
//]]>
</script>
    </ul>
    <div class="clear"></div>

  </div>
  <div class="clear"></div>
</div><!--/header-main-->


              <div id="search-detail-field"></div>
            </div>

            <div id='nt_ext_global_nav'>
<div id='main-navi'>
<ul class='list-nav list-nav-main'>
<li class='sagasu_label '>
<a href="/">レシピをさがす</a>
</li>
<li class='ps_sagasu_label '>
<a href="/about/ps?g=global_menu_ranking" class="track-pslink" track_pslink_place="global_nav">人気順でさがす</a>
</li>
<li class='noseru_label ' id='post_recipe'>
<script type="text/javascript">
//<![CDATA[
var post_recipe = new SwitchByCookie();post_recipe.add({'has_kitchen':'0', 'user_type':'1'},'<a href=\"/recipe/post\" data-confirm=\"レシピをのせるにはMYキッチンの開設（無料）が必要です。MYキッチンを開設しますか？\">レシピをのせる<\/a>');
post_recipe.add({'user_type':'0'},'<a href=\"/login?rt=%252Frecipe%252Fpost&amp;type=recipe_post\" class=\"link_to_login\" id=\"link_to_recipe_post\" params=\"dialog_width=760,dialog_height=390,dialog_title=\">レシピをのせる<\/a>');
post_recipe.add_default('<a href=\"/recipe/post\">レシピをのせる<\/a>');
post_recipe.render('post_recipe');

//]]>
</script>

</li>

</ul>
<div class='sign' id='user_functions'>
<ul class='list-nav' id='main_nav_right'>
<li id="welcome"><noscript><a href="/user/regist">クックパッドID（無料）を登録する</a><span class="pipe">｜</span>

</noscript></li>
<li id="status"><noscript><a href="/login" class="link_to_login" params="dialog_width=350,dialog_height=390,dialog_title=">ログイン</a><span class="pipe">｜</span>
</noscript></li>
<li id='user_info'>
<script type="text/javascript">
//<![CDATA[
var user_info = new SwitchByCookie();user_info.add({'user_type':['2' , '1' ]},'<a href=\"/user/edit\">登録情報<\/a>｜');
user_info.add_default('');
user_info.render('user_info');

//]]>
</script>
</li>
<li id='help'>
<a href="http://cookpad.typepad.jp/help/" target="_blank">ヘルプ</a>
</li>
</ul>
</div>
</div>
</div>

          </div>

        <div id="contents">
          


          
          <div id="main" class="main650 ">
            
            

            
            <!---->
              <div id="main-cont-top-650"></div>

            




<div id="one-col">
  <div id="recipe" data-recipe_id="117485">

    <div class="separate_wrapper" style="width: 610px;margin-bottom: 10px;">
              <a href="/recipe/list/36109">&laquo;<span class="author">お気楽主婦 </span>のレシピ</a>
        <span class="item_count">
          (247品)
        </span>

  <div id="_footstamp_tools" class="separate_right" style="bottom: 0px;">
      <ul class="list-nav utility_nav" style="">
    
    
        <li id="post_myfolder_recipe_top">
          <span id="myfolder_recipe_117485_top">&nbsp;</span>
        </li>
    
      <li id="email_icon">
        <a href="/recipe/introduce/117485?page_type=1" class="colorbox_link" data-dialog_height="470" data-dialog_width="500" data-iframe="true"><img alt="メールする" src="/images/shared/email.gif?1318414276" /></a>
      </li>
      <li>
        <a href="/recipe/introduce_for_keitai/117485?page_type=1" class="colorbox_link" data-dialog_height="445" data-dialog_width="500" data-iframe="true"><img alt="携帯に送る" src="/images/shared/phone.gif?1318414276" /></a>
      </li>

    
      <li>
        <a href="/recipe/print/117485?page_type=1" target="_blank" title="印刷する"><img alt="印刷する" src="/images/shared/printer.gif?1318414276" /></a>
      </li>
      <li id="post_tsukurepo">
        <script type="text/javascript">
//<![CDATA[

          var post_tsukurepo = new SwitchByCookie();
          post_tsukurepo.add({"user_type": ['2', '1'], "has_kitchen": ['1']}, "<a href=\"/tsukurepo/post?page_type=3&amp;recipe_id=117485\" class=\"colorbox_link\" data-dialog_height=\"550\" data-dialog_width=\"500\" data-iframe=\"true\" style=\"text-decoration: none;\" title=\"このレシピのつくれぽを書く\"><img alt=\"このレシピのつくれぽを書く\" src=\"/images/shared/tsukurepo.gif?1318414276\" style=\"vertical-align: top;\" /><\/a>");
          post_tsukurepo.add({"user_type": ['2', '1'], "has_kitchen": ['0']}, "<a href=\"/kitchen/regist?rt=%2Frecipe%2F117485%40tsukurepo\" data-confirm=\"つくりましたフォトレポート「つくれぽ」を書くにはMYキッチンの開設（無料）が必要です。MYキッチンを開設しますか？\" title=\"このレシピのつくれぽを書く\"><img alt=\"Tsukurepo\" src=\"/images/shared/tsukurepo.gif?1318414276\" /><\/a>");
          post_tsukurepo.add_default('<a href=\"/login?type=tsukurepo\" class=\"link_to_login\" params=\"dialog_width=350,dialog_height=390,dialog_title=\" title=\"このレシピのつくれぽを書く\"><img alt=\"Tsukurepo\" src=\"/images/shared/tsukurepo.gif?1318414276\" /><\/a>');
          post_tsukurepo.render("post_tsukurepo");
         
//]]>
</script>
      </li>

  </ul>

  </div>
</div>



    <div id="recipe-main" style="margin-top: -5px">
      <div id="recipe-title">
  <div class="f_right" style="margin-top: 2px;">
    <span class="small" style="color: #999;">
  レシピID :117485
</span>
  </div>
  <h1 class="recipe-title fn">
      酸辣湯（すっぱ辛い中華スープ）
  </h1>
  <div class="clear"></div>
  <div id="recipe_title_update_error" class="error" style='font-size: 11px'></div>
</div>




  
        <div id="main-photo">
          <img alt="酸辣湯（すっぱ辛い中華スープ）" class="photo" src="http://d3921.cpcdn.com/recipes/117485/280/38a270c05e251d1e7d36f00485a1861d.jpg?u=36109&amp;p=1219145947" width="280" /><br/>
        </div>

<a name="description"></a>
<div class="desc-and-ingredients">
  <div id="description" class="font14 summary">
      我が家の好評メニューです。<br />暑い夏にも良いけれど、寒い季節にも最高♪<br />2008.8.19、分量を少々見直しました。

    
      

    <div class="right">
    <img alt="お気楽主婦" height="20" src="http://d3921.cpcdn.com/users/36109/20x20c/a19bfdae55e902e39e05323473419a88.jpg?u=36109&amp;p=1229196798" style="vertical-align: middle;" width="20" />
    <a href="/kitchen/36109">お気楽主婦</a>
    </div>
  </div>

  
    <div id="ingredients">
      <div class='servings'>
<h3 class='servings_title'>
<span>
材料
</span>
<span class='servings_for'>
（
2～3人分
）
</span>


</h3>
</div>
<div id='ingredients_list'>
<div class='ingredient_row'>
<div class='ingredient_name'>
竹の子水煮（細切り）
</div>
<div class='ingredient_quantity'>
３０ｇ
</div>
</div>
<div class='ingredient_row'>
<div class='ingredient_name'>
椎茸
</div>
<div class='ingredient_quantity'>
１枚
</div>
</div>
<div class='ingredient_row'>
<div class='ingredient_name'>
にんじん
</div>
<div class='ingredient_quantity'>
３０ｇ
</div>
</div>
<div class='ingredient_row'>
<div class='ingredient_name'>
絹ごし豆腐
</div>
<div class='ingredient_quantity'>
１００ｇ
</div>
</div>
<div class='ingredient_row'>
<div class='ingredient_name'>
豚バラスライス
</div>
<div class='ingredient_quantity'>
５０ｇ
</div>
</div>
<div class='ingredient_row'>
<div class='ingredient_name'>
水
</div>
<div class='ingredient_quantity'>
６００cc
</div>
</div>
<div class='ingredient_row'>
<div class='ingredient_name'>
顆粒鶏がらスープ
</div>
<div class='ingredient_quantity'>
大さじ１
</div>
</div>
<div class='ingredient_row'>
<div class='ingredient_name'>
卵
</div>
<div class='ingredient_quantity'>
１個
</div>
</div>
<div class='ingredient_row'>
<div class='ingredient_name'>
万能ねぎor三つ葉
</div>
<div class='ingredient_quantity'>
適量
</div>
</div>
<div class='ingredient_row'>
<div class='ingredient_category'>
<span>■</span>
～調味料～
</div>
</div>
<div class='ingredient_row'>
<div class='ingredient_name'>
★醤油
</div>
<div class='ingredient_quantity'>
大さじ１
</div>
</div>
<div class='ingredient_row'>
<div class='ingredient_name'>
★塩
</div>
<div class='ingredient_quantity'>
小さじ１/２
</div>
</div>
<div class='ingredient_row'>
<div class='ingredient_name'>
★こしょう
</div>
<div class='ingredient_quantity'>
（好みで調節）小さじ1/4
</div>
</div>
<div class='ingredient_row'>
<div class='ingredient_name'>
★ラー油
</div>
<div class='ingredient_quantity'>
（好みで調節）小さじ１
</div>
</div>
<div class='ingredient_row'>
<div class='ingredient_name'>
水溶き片栗粉
</div>
<div class='ingredient_quantity'>
大さじ１～２
</div>
</div>
<div class='ingredient_row'>
<div class='ingredient_name'>
●酢
</div>
<div class='ingredient_quantity'>
大さじ２
</div>
</div>
</div>
<style>
  /*<![CDATA[*/
    #ingredients div.servings {
      border-bottom: 1px solid #E5E5E5;
    }
    
    #ingredients div.servings .servings_title {
      color: #E0D7C1;
    }
    
    #ingredients div.servings .servings_for {
      font-size: 12px;
      font-weight: normal;
      color: #4c4c4c;
    }
    
    #ingredients #ingredients_list {
      color: #4C4C4C;
    }
    
    #ingredients #ingredients_list .ingredient_row {
      border-bottom: 1px solid #E5E5E5;
      overflow: hidden;
      padding: 1px 5px;
      zoom: 1;
    }
    
    #ingredients #ingredients_list .ingredient_name {
      display: inline;
      float: left;
      font-size: 108%;
    }
    
    #ingredients #ingredients_list .ingredient_quantity {
      display: inline;
      float: right;
      margin: 0 0 0 10px;
      text-align: right;
      min-width: 4em;
    }
    
    #ingredients #ingredients_list .ingredient_category {
      display: inline;
      float: left;
      font-weight: bold;
      padding-top: 12px;
    }
  /*]]>*/
</style>

    </div>

</div>

<div class="clear"></div>

    </div>

    

    
      <div id="steps" class="instructions">
          <div class='step'>
<dl>
<dt id='step_head_555858'>
<h3>1</h3>
</dt>
<dd class='instruction'>
<div id='recipe-step_photo_555858'>
<div class='image'>
<img alt="写真" src="http://d3921.cpcdn.com/steps/555858/136/6abcb5006edc59dedc9a64d48ea891c0.jpg?u=36109&amp;p=1219145993" />
</div>
</div>
<p class='font14' id='step_text_555858'>椎茸、にんじん、豚バラ肉、豆腐は細切りにする。竹の子水煮も細切りタイプでない場合は細切りに。<br /></p>
</dd>
</dl>
</div>
<div class='step'>
<dl>
<dt id='step_head_555859'>
<h3>2</h3>
</dt>
<dd class='instruction'>
<div id='recipe-step_photo_555859'>
<div class='image'>
<img alt="写真" src="http://d3921.cpcdn.com/steps/555859/136/5f6446a2629444b671ce2d35593c8852.jpg?u=36109&amp;p=1219146044" />
</div>
</div>
<p class='font14' id='step_text_555859'>鍋に水と鶏がらスープを入れ沸騰させ、椎茸、にんじん、豚バラ肉、竹の子を入れ煮立たせ、材料が柔らかくなったら豆腐を加える。</p>
</dd>
</dl>
</div>
<div class='step'>
<dl>
<dt id='step_head_2962322'>
<h3>3</h3>
</dt>
<dd class='instruction'>
<div id='recipe-step_photo_2962322'>
<div class='image'>
<img alt="写真" src="http://d3921.cpcdn.com/steps/2962322/136/99f11a24bf28591c618e8748476d4227.jpg?u=36109&amp;p=1219146080" />
</div>
</div>
<p class='font14' id='step_text_2962322'>②に★の調味料を加えて一煮立ちさせる。</p>
</dd>
</dl>
</div>
<div class='step_last'>
<dl>
<dt id='step_head_555860'>
<h3>4</h3>
</dt>
<dd class='instruction'>
<div id='recipe-step_photo_555860'>
<div class='image'>
<img alt="写真" src="http://d3921.cpcdn.com/steps/555860/136/4a8cd48096f7cd809c2e575e9ad9088d.jpg?u=36109&amp;p=1219146113" />
</div>
</div>
<p class='font14' id='step_text_555860'>煮立ったら水溶き片栗粉を入れ、とろみをつけ再び煮立ったら火を弱め、溶き卵を流し入れ卵がフワっと浮いてきたら火を消す。</p>
</dd>
</dl>
</div>
<div class='clear'></div>
<div class='step'>
<dl>
<dt id='step_head_555871'>
<h3>5</h3>
</dt>
<dd class='instruction'>
<div id='recipe-step_photo_555871'>
<div class='image'>
<img alt="写真" src="http://d3921.cpcdn.com/steps/555871/136/5fb29afc25f2a14afd35dbaccc671d7d.jpg?u=36109&amp;p=1219146153" />
</div>
</div>
<p class='font14' id='step_text_555871'>火を消した後に●の酢を加えて器に盛り付ける。三つ葉や万能ねぎを最後に散らしまして出来上がり＾＾</p>
</dd>
</dl>
</div>
<div class='step'>
<dl>
<dt id='step_head_2961184'>
<h3>6</h3>
</dt>
<dd class='instruction'>
<div id='recipe-step_photo_2961184'>
<div class='image'>
<img alt="写真" src="http://d3921.cpcdn.com/steps/2961184/136/78d27f5cdca8ba3e074bf9a42ad30213.jpg?u=36109&amp;p=1219108099" />
</div>
</div>
<p class='font14' id='step_text_2961184'>2008.8.19皆さんのおかげで話題入りさせて頂きました☆ <br />作ってくださった皆さん、ありがとうございます=^_^=</p>
</dd>
</dl>
</div>
<div class='clear'></div>

      </div>

    
      <a name="advice"></a>
<div class="cont-wrapper">
    <h3 class="borderless">コツ・ポイント</h3>
    <div class="font14" id="advice">
      ★卵は片栗粉でとろみをつけた後で流し入れてくださいね。　★中華麺を茹でてこのスープをかけて「酸辣湯麺」にするのも美味しいですよ。
    </div>

</div>



    
        


      
        <style type="text/css">
  #tools-bottom-table td {
    padding: 4px;
  }
</style>

<div class="cont-wrapper" style="text-align: center; background: #f5f5f5; border: 1px solid #d6d7b9; padding: 8px;">
  <ul id="tool-list" style="margin-left: 80px;">
    
    <li>
      <span data-page_type="2" id="myfolder_recipe_117485_bottom"></span>
    </li>
    <li id="email_icon_with_message">
      <a href="/recipe/introduce/117485?page_type=2" class="colorbox_link email-icon-with-text" data-dialog_height="470" data-dialog_width="500" data-iframe="true">メールする</a>
    </li>
    <li>
      <img alt="Phone" src="/images/shared/phone.gif?1318414276" style="vertical-align: middle;" />
      <a href="/recipe/introduce_for_keitai/117485?page_type=2" class="colorbox_link" data-dialog_height="445" data-dialog_width="500" data-iframe="true">携帯に送る</a>
    </li>
    <li style="padding: 0px;">
      <a href="/recipe/print/117485?page_type=2" class="print-icon-with-text" target="_blank">印刷する</a>
    </li>
  </ul>

  <div class="clear"></div>
  
</div>




      

      
        
          
            
<div id='tsukurepo_container'>
<div id='tsukurepo-header'></div>
<div id='tsukurepo'>
<a name='tsukurepo'></a>
<div class='separate_wrapper tsukurepo_title'>
<h2 class='content_title_with_line'>
みんなのつくりましたフォトレポート「つくれぽ」
</h2>
<div class='separate_right'><span class='tsukurepo_count'>27</span>件
<span class='tsukurepo_uu_count'>
(26人)
</span>
</div>
</div>
<div id='tsukurepo-list'>
<div class='tsukurepo-wrapper'>
<div class='tsukurepo'>
<div class='tsukurepo-inner'>
<div class='tsukurepo_info'>
<p class='date'>
12/05/18
</p>
<p class='right delete_link'>

</p>
</div>
<div class='image'>
<img alt="写真" class="tsukurepo-photo" height="120" src="http://d3921.cpcdn.com/tsukurepos/5285074/120x120c/b06a01f65bc4746de66a9bd506c7dc31.jpg?u=720985&amp;p=1337288269" width="120" />
</div>

<p class='message'>ｶﾆｶﾏと干し椎茸とﾆﾝﾆｸの芽も足して具沢山にしました☆</p>
<p class='tsukurepo-author font11'>
<a href="/kitchen/720985"><img alt="" height="16" src="http://d3921.cpcdn.com/users/720985/16x16c/668b5fd42d8f571f45f67bb7f8f99c87.jpg?u=720985&amp;p=1214186098" width="16" /></a>
<a href="/kitchen/720985">こずぅ粘土</a>
</p>
<div class='clear'></div>
</div>
</div>
<p class="comment">具沢山でとても美味しそう♪素敵なれぽをありがとうございます♡</p>
</div>


<div class='tsukurepo-wrapper'>
<div class='tsukurepo'>
<div class='tsukurepo-inner'>
<div class='tsukurepo_info'>
<p class='date'>
12/05/13
</p>
<p class='right delete_link'>

</p>
</div>
<div class='image'>
<img alt="写真" class="tsukurepo-photo" height="120" src="http://d3921.cpcdn.com/tsukurepos/5256519/120x120c/0d53e1553f737c7d266891080cbd1f8e.jpg?u=1512669&amp;p=1336900810" width="120" />
</div>

<p class='message'>お酢た～っぷり増量で(*´ω｀*)
美味しかったのでりぴ決定！</p>
<p class='tsukurepo-author font11'>
<a href="/kitchen/1512669"><img alt="" height="16" src="http://d3921.cpcdn.com/users/1512669/16x16c/786eded831d143f712c79bbb97a1e34e.jpg?u=1512669&amp;p=1250145653" width="16" /></a>
<a href="/kitchen/1512669">き～もも</a>
</p>
<div class='clear'></div>
</div>
</div>
<p class="comment">お酢たっぷりもおいしいですねよね＾＾素敵なれぽをありがとう♡</p>
</div>


<div class='tsukurepo-wrapper'>
<div class='tsukurepo'>
<div class='tsukurepo-inner'>
<div class='tsukurepo_info'>
<p class='date'>
12/05/12
</p>
<p class='right delete_link'>

</p>
</div>
<div class='image'>
<img alt="写真" class="tsukurepo-photo" height="120" src="http://d3921.cpcdn.com/tsukurepos/5251434/120x120c/b7a850312b7a382ecf842f51c8ff4305.jpg?u=3875486&amp;p=1336819856" width="120" />
</div>

<p class='message'>簡単で美味しい☆はまりました。次は、具を色々かえて作ります</p>
<p class='tsukurepo-author font11'>
<a href="/kitchen/3875486"><img alt="" height="16" src="/images/themes/kitchen/profile.gif?1318414277" width="16" /></a>
<a href="/kitchen/3875486">カズチカ</a>
</p>
<div class='clear'></div>
</div>
</div>
<p class="comment">是非色々な具で試してくださいね＾＾素敵なれぽをありがとう♡</p>
</div>


<div class='tsukurepo-wrapper-last'>
<div class='tsukurepo'>
<div class='tsukurepo-inner'>
<div class='tsukurepo_info'>
<p class='date'>
12/04/30
</p>
<p class='right delete_link'>

</p>
</div>
<div class='image'>
<img alt="写真" class="tsukurepo-photo" height="120" src="http://d3921.cpcdn.com/tsukurepos/5186593/120x120c/d48ef95f6a810982fb508a094e18cc81.jpg?u=4250504&amp;p=1335779890" width="120" />
</div>

<p class='message'>作ってみました！結構簡単に作れて美味しかったです！</p>
<p class='tsukurepo-author font11'>
<a href="/kitchen/4250504"><img alt="" height="16" src="/images/themes/kitchen/profile.gif?1318414277" width="16" /></a>
<a href="/kitchen/4250504">TA398</a>
</p>
<div class='clear'></div>
</div>
</div>
<p class="comment">とても美味しそうなれぽをありがとう＾＾また作ってくださいね♡</p>
</div>

<div class='clear'></div>
<div class='tsukurepo-wrapper'>
<div class='tsukurepo'>
<div class='tsukurepo-inner'>
<div class='tsukurepo_info'>
<p class='date'>
12/04/21
</p>
<p class='right delete_link'>

</p>
</div>
<div class='image'>
<img alt="写真" class="tsukurepo-photo" height="120" src="http://d3921.cpcdn.com/tsukurepos/5138364/120x120c/a547f1700fedf3aec96a7f743172e8ee.jpg?u=4252539&amp;p=1335013420" width="120" />
</div>

<p class='message'>中華な夕食に！すっぱおいしくて好評でした！</p>
<p class='tsukurepo-author font11'>
<a href="/kitchen/4252539"><img alt="" height="16" src="/images/themes/kitchen/profile.gif?1318414277" width="16" /></a>
<a href="/kitchen/4252539">reunie</a>
</p>
<div class='clear'></div>
</div>
</div>
<p class="comment">美味しそうな晩御飯ですね！作ってくださってありがとうです＾＾</p>
</div>


<div class='tsukurepo-wrapper'>
<div class='tsukurepo'>
<div class='tsukurepo-inner'>
<div class='tsukurepo_info'>
<p class='date'>
12/04/08
</p>
<p class='right delete_link'>

</p>
</div>
<div class='image'>
<img alt="写真" class="tsukurepo-photo" height="120" src="http://d3921.cpcdn.com/tsukurepos/5063099/120x120c/cb9b780d41b78b23ed425f57ca2871bb.jpg?u=2247793&amp;p=1333842824" width="120" />
</div>

<p class='message'>とても美味しかったです。</p>
<p class='tsukurepo-author font11'>
<a href="/kitchen/2247793"><img alt="" height="16" src="http://d3921.cpcdn.com/users/2247793/16x16c/78254ce046f2766f374e80d822087945.jpg?u=2247793&amp;p=1320045739" width="16" /></a>
<a href="/kitchen/2247793">華雪比呂</a>
</p>
<div class='clear'></div>
</div>
</div>
<p class="comment">彩りが綺麗で美味しそう＾＾素敵なれぽをありがとうございます♪</p>
</div>


<div class='tsukurepo-wrapper'>
<div class='tsukurepo'>
<div class='tsukurepo-inner'>
<div class='tsukurepo_info'>
<p class='date'>
11/11/03
</p>
<p class='right delete_link'>

</p>
</div>
<div class='image'>
<img alt="写真" class="tsukurepo-photo" height="120" src="http://d3921.cpcdn.com/tsukurepos/4430056/120x120c/82247cae504308f40591d6b98496f2e1.jpg?u=2230145&amp;p=1320285642" width="120" />
</div>

<p class='message'>子供らのリクエストで作りました♪hot&amp;sour～！ハマリますね</p>
<p class='tsukurepo-author font11'>
<a href="/kitchen/2230145"><img alt="" height="16" src="http://d3921.cpcdn.com/users/2230145/16x16c/7ba4210ecaee56ebfc3994abbd6702cd.jpg?u=2230145&amp;p=1327655082" width="16" /></a>
<a href="/kitchen/2230145">ぐーたらレシピ研究所</a>
</p>
<div class='clear'></div>
</div>
</div>
<p class="comment">掲載遅れてごめんなさい。素敵なれぽをありがとうございます＾＾</p>
</div>


<div class='tsukurepo-wrapper-last'>
<div class='tsukurepo'>
<div class='tsukurepo-inner'>
<div class='tsukurepo_info'>
<p class='date'>
11/10/08
</p>
<p class='right delete_link'>

</p>
</div>
<div class='image'>
<img alt="写真" class="tsukurepo-photo" height="120" src="http://d3921.cpcdn.com/tsukurepos/4340341/120x120c/5103f6257b69f89182f8ded5b6f1e716.jpg?u=1854474&amp;p=1318077959" width="120" />
</div>

<p class='message'>だいすきー^^中華麺を入れていただきました♪♪大満足☆☆☆</p>
<p class='tsukurepo-author font11'>
<a href="/kitchen/1854474"><img alt="" height="16" src="/images/themes/kitchen/profile.gif?1318414277" width="16" /></a>
<a href="/kitchen/1854474">ponsyuke♪</a>
</p>
<div class='clear'></div>
</div>
</div>
<p class="comment">私も中華麺入れるのが好きです♪素敵なれぽをありがとうです♡</p>
</div>

<div class='clear'></div>
<div class='tsukurepo-wrapper'>
<div class='tsukurepo'>
<div class='tsukurepo-inner'>
<div class='tsukurepo_info'>
<p class='date'>
11/09/28
</p>
<p class='right delete_link'>

</p>
</div>
<div class='image'>
<img alt="写真" class="tsukurepo-photo" height="120" src="http://d3921.cpcdn.com/tsukurepos/4304963/120x120c/b0c36fc8ba2852e036a5ccc3bf70d8c6.jpg?u=3522908&amp;p=1317178304" width="120" />
</div>

<p class='message'>はじめて作りました。すっぱおいしい★</p>
<p class='tsukurepo-author font11'>
<a href="/kitchen/3522908"><img alt="" height="16" src="/images/themes/kitchen/profile.gif?1318414277" width="16" /></a>
<a href="/kitchen/3522908">riecong</a>
</p>
<div class='clear'></div>
</div>
</div>
<p class="comment">美味しそうなお写真と嬉しいコメントをありがとうございます♡</p>
</div>


<div class='tsukurepo-wrapper'>
<div class='tsukurepo'>
<div class='tsukurepo-inner'>
<div class='tsukurepo_info'>
<p class='date'>
10/05/24
</p>
<p class='right delete_link'>

</p>
</div>
<div class='image'>
<img alt="写真" class="tsukurepo-photo" height="120" src="http://d3921.cpcdn.com/tsukurepos/2633686/120x120c/4b437ea841b8badf2b538c27a5ec5a0a.jpg?u=1320540&amp;p=1274656789" width="120" />
</div>

<p class='message'>何度もリピしてます★夫の大好物で、家でこの美味しさ作れて感謝です</p>
<p class='tsukurepo-author font11'>
<a href="/kitchen/1320540"><img alt="" height="16" src="/images/themes/kitchen/profile.gif?1318414277" width="16" /></a>
<a href="/kitchen/1320540">leluu</a>
</p>
<div class='clear'></div>
</div>
</div>
<p class="comment">何度も作ってくださっているなんて感激❤また作ってくださいね♪</p>
</div>


<div class='tsukurepo-wrapper'>
<div class='tsukurepo'>
<div class='tsukurepo-inner'>
<div class='tsukurepo_info'>
<p class='date'>
10/04/14
</p>
<p class='right delete_link'>

</p>
</div>
<div class='image'>
<img alt="写真" class="tsukurepo-photo" height="120" src="http://d3921.cpcdn.com/tsukurepos/2489032/120x120c/bb4bdcb13c1d9b138c6b88de27ce6629.jpg?u=324404&amp;p=1271197885" width="120" />
</div>

<p class='message'>旦那様、おかわり３杯してくれました！美味しかったです♪</p>
<p class='tsukurepo-author font11'>
<a href="/kitchen/324404"><img alt="" height="16" src="http://d3921.cpcdn.com/users/324404/16x16c/184888428eb4fb7810e997073a29c794.jpg?u=324404&amp;p=1214156832" width="16" /></a>
<a href="/kitchen/324404">まんちーず</a>
</p>
<div class='clear'></div>
</div>
</div>
<p class="comment">れぽ、ありがとうございます(*^▽^*)とても美味しそう♪</p>
</div>


<div class='tsukurepo-wrapper-last'>
<div class='tsukurepo'>
<div class='tsukurepo-inner'>
<div class='tsukurepo_info'>
<p class='date'>
10/01/09
</p>
<p class='right delete_link'>

</p>
</div>
<div class='image'>
<img alt="写真" class="tsukurepo-photo" height="120" src="http://d3921.cpcdn.com/tsukurepos/2143713/120x120c/2a82147be30f8f30ec99b8ddeb698b0c.jpg?u=1361998&amp;p=1263003474" width="120" />
</div>

<p class='message'>簡単だし何回も作ってます。美味です。我が家の定番メニューです。</p>
<p class='tsukurepo-author font11'>
<a href="/kitchen/1361998"><img alt="" height="16" src="http://d3921.cpcdn.com/users/1361998/16x16c/af65bb670f34909172a76a25a2ec8d42.jpg?u=1361998&amp;p=1264069184" width="16" /></a>
<a href="/kitchen/1361998">hanamamy</a>
</p>
<div class='clear'></div>
</div>
</div>
<p class="comment">何回も作ってくださってるのですか？嬉しいコメントありがとう❤</p>
</div>

<div class='clear'></div>
<div class='paginate center'>
  

        <span class="current_page">1</span>
</span>


        <a href="/recipe/tsukurepo_list_by_recipe/117485?t_page=2" data-remote="true">2</a>
</span>


        <a href="/recipe/tsukurepo_list_by_recipe/117485?t_page=3" data-remote="true">3</a>
</span>

  <a href="/recipe/tsukurepo_list_by_recipe/117485?t_page=2" data-remote="true" rel="next">&nbsp;<span class='next_page' rel='next'>次へ</span>&raquo;</a>


</div>
</div>
<script>
  //<![CDATA[
    function submit_function(default_message){
      if (jQuery('#tsukurepos_search_term').val() == default_message) {
        jQuery('#tsukurepos_search_term').val('');
      }
      jQuery('#tsukurepos_search_form').submit();
    }
  //]]>
</script>

<a name='tsukurepo_post'></a>
<div class='clear' style='text-align: center;margin:20px 0 5px'>
<span id='tsukurepo_content_for'></span>
<script type="text/javascript">
//<![CDATA[
var tsukurepo_content_for = new SwitchByCookie();tsukurepo_content_for.add({'has_kitchen':'1', 'user_type':['1' , '2' ]},'<a href=\"/tsukurepo/post?page_type=6&amp;recipe_id=117485\" class=\"ckpd-button 1552c345b0fe67e42e8c2cc4ee068282 colorbox_link\" data-dialog_height=\"550\" data-dialog_width=\"500\" data-iframe=\"true\"><span class=\"ckpd-icon ckpd-icon-tsukurepo\"><\/span><span class=\"ckpd-button-text\">つくれぽを書く<\/span><\/a><script>Ckpd.UI.Button.init($(\'a.1552c345b0fe67e42e8c2cc4ee068282\'));<\/script>');
tsukurepo_content_for.add({'has_kitchen':'0', 'user_type':['1' , '2' ]},'<a href=\"/kitchen/regist?rt=%2Frecipe%2F117485\" class=\"ckpd-button 91dcaa789e1aa9e051180d83a6a4bf34 \" data-confirm=\"つくりましたフォトレポート「つくれぽ」を書くにはMYキッチンの開設（無料）が必要です。MYキッチンを開設しますか？\"><span class=\"ckpd-icon ckpd-icon-tsukurepo\"><\/span><span class=\"ckpd-button-text\">つくれぽを書く<\/span><\/a><script>Ckpd.UI.Button.init($(\'a.91dcaa789e1aa9e051180d83a6a4bf34\'));<\/script>');
tsukurepo_content_for.add_default('<a href=\"/login\" class=\"ckpd-button bcbd9618de5d35953b7e714787bfbba1 link_to_login\" params=\"dialog_width=350,dialog_height=390,dialog_title=\"><span class=\"ckpd-icon ckpd-icon-tsukurepo\"><\/span><span class=\"ckpd-button-text\">つくれぽを書く<\/span><\/a><script>Ckpd.UI.Button.init($(\'a.bcbd9618de5d35953b7e714787bfbba1\'));<\/script>');
tsukurepo_content_for.render('tsukurepo_content_for');

//]]>
</script></div>
</div>
<div id='tsukurepo-footer'></div>
</div>


    
      
        
          <!-- コメント欄 -->
<a name='history'></a>
<div class='cont-wrapper'>
<div class='separate_wrapper history_title'>
<h2 class='content_title_with_line'>
このレシピの生い立ち
</h2>
<div class='separate_right recipe_publish_date'>
公開日：
<span class='published' id='published_date'><span class='value-title' title='2003-11-18'></span>03/11/18</span>
</div>
</div>
<div class='history_content' id='history'>
食堂で「酸辣湯麺」を食べ病みつきに・・・。使用する調味料は分かったので独自で配分を模索しました。
</div>
</div>

          <div class='separate_wrapper easy_link_title'>
<h2 class='content_title_with_line'>
簡単リンク
</h2>
<div class='separate_right' style='color: #999; font-size: 85%; top: 0px;'>
外部のブログにこのレシピのリンクを貼れます
</div>
</div>
<div id='easy-link'>
<table id='link-table'>
<tr>
<th>
外部ブログ用
</th>
<td>
<input id="" type="text" value="&lt;a href=&quot;http://cookpad.com&quot; target=&quot;_blank&quot;&gt;&lt;img alt=&quot;Cpicon&quot; src=&quot;http://img3.cookpad.com/image/link/cpicon.gif&quot; style=&quot;border: 0px; vertical-align: middle;&quot; /&gt;&lt;/a&gt; &lt;a href=&quot;http://cookpad.com/recipe/117485&quot; style=&quot;color:#9ea73d;font-weight:bold;&quot; target=&quot;_blank&quot;&gt;酸辣湯（すっぱ辛い中華スープ） by お気楽主婦&lt;/a&gt;" />
</td>
</tr>
</table>
<script>
  //<![CDATA[
    $('#easy-link input[type=text]').click(function() {
      $(this).select();
    });
  //]]>
</script>
<div class="extension ext_recipe_embed_log_ext ext_recipe_embed_log_ext-log_easy_link"><script>
  //<![CDATA[
    $('#easy-link input[type=text]').click(function() {
      $.get('/recipe/embed_action_log?type=easy_link');
    });
  //]]>
</script>
</div>
</div>


      
        <div id="category" class="category cont-wrapper">
  <div id="category_list">

    <h2 class="content_title_with_line category_title">
      このレシピが登録されているカテゴリ
    </h2>

    <ul>
      <li>
        <a href="/category/177">今日の献立</a> >
        <a href="/category/15">シチュー・スープ・汁物</a> >
        <a href="/category/137" class="tag">中華スープ</a>
      </li>
    </ul>
    <ul>
      <li>
        <a href="/category/1502">その他</a> >
        <a href="/category/1766">中華料理</a> >
        <a href="/category/1772" class="tag">サンラータン</a>
      </li>
    </ul>
  </div>

  <div class="recommend" style="text-align: right;" id="recommend_link">

    <script type="text/javascript">
//<![CDATA[
var recommend_link = new SwitchByCookie();recommend_link.add({'user_type':['1' , '2' ]},'<a href=\"/category/recommend?recipe_id=117485&amp;rt=%2Frecipe%2F117485\">このレシピをカテゴリに推薦する&raquo;<\/a>');
recommend_link.add_default('<a href=\"/login?rt=%252Fcategory%252Frecommend%253Frecipe_id%253D117485&amp;type=category_recommend\" class=\"link_to_login\" params=\"dialog_width=350,dialog_height=390,dialog_title=\">このレシピをカテゴリに推薦する&raquo;<\/a>');
recommend_link.render('recommend_link');

//]]>
</script>
  </div>
</div>


  <a name="ranking"></a>

  <div class="cont-wrapper">
    <h2 class="content_title_with_line ranking_title">
      このレシピの人気ランキング
    </h2>
    <ul>
        <li>
        <span id="keyword_recipe_ranking_link_19884"></span>
          <script type="text/javascript">
//<![CDATA[
var keyword_recipe_ranking_link_19884 = new SwitchByCookie();keyword_recipe_ranking_link_19884.add({'user_type':'2'},'<a href=\"/%E3%83%AC%E3%82%B7%E3%83%94/%E6%B9%AF?order=popularity\" class=\"keyword_ranking_link\">湯<\/a>の人気検索で');
keyword_recipe_ranking_link_19884.add_default('<a href=\"/%E3%83%AC%E3%82%B7%E3%83%94/%E6%B9%AF\">湯<\/a>の人気検索で');
keyword_recipe_ranking_link_19884.render('keyword_recipe_ranking_link_19884');

//]]>
</script>
          <span class="bold">
            4位
          </span>
        </li>
        <li>
        <span id="keyword_recipe_ranking_link_6022"></span>
          <script type="text/javascript">
//<![CDATA[
var keyword_recipe_ranking_link_6022 = new SwitchByCookie();keyword_recipe_ranking_link_6022.add({'user_type':'2'},'<a href=\"/%E3%83%AC%E3%82%B7%E3%83%94/%E3%82%B5%E3%83%B3%E3%83%A9%E3%83%BC%E3%82%BF%E3%83%B3?order=popularity\" class=\"keyword_ranking_link\">サンラータン<\/a>の人気検索で');
keyword_recipe_ranking_link_6022.add_default('<a href=\"/%E3%83%AC%E3%82%B7%E3%83%94/%E3%82%B5%E3%83%B3%E3%83%A9%E3%83%BC%E3%82%BF%E3%83%B3\">サンラータン<\/a>の人気検索で');
keyword_recipe_ranking_link_6022.render('keyword_recipe_ranking_link_6022');

//]]>
</script>
          <span class="bold">
            4位
          </span>
        </li>
        <li>
        <span id="keyword_recipe_ranking_link_2680"></span>
          <script type="text/javascript">
//<![CDATA[
var keyword_recipe_ranking_link_2680 = new SwitchByCookie();keyword_recipe_ranking_link_2680.add({'user_type':'2'},'<a href=\"/%E3%83%AC%E3%82%B7%E3%83%94/%E4%B8%AD%E8%8F%AF%E3%82%B9%E3%83%BC%E3%83%97?order=popularity\" class=\"keyword_ranking_link\">中華スープ<\/a>の人気検索で');
keyword_recipe_ranking_link_2680.add_default('<a href=\"/%E3%83%AC%E3%82%B7%E3%83%94/%E4%B8%AD%E8%8F%AF%E3%82%B9%E3%83%BC%E3%83%97\">中華スープ<\/a>の人気検索で');
keyword_recipe_ranking_link_2680.render('keyword_recipe_ranking_link_2680');

//]]>
</script>
          <span class="bold">
            4位
          </span>
        </li>
    </ul>
  </div>
  <div class="cont-wrapper">
    <h2 class="content_title_with_line ranking_title">
      このレシピの関連キーワード
    </h2>
    <div class='related_keywords'>
      <a href="/%E3%83%AC%E3%82%B7%E3%83%94/%E7%AB%B9%E3%81%AE%E5%AD%90%E6%B0%B4%E7%85%AE">竹の子水煮</a> <a href="/%E3%83%AC%E3%82%B7%E3%83%94/%E6%A4%8E%E8%8C%B8">椎茸</a> <a href="/%E3%83%AC%E3%82%B7%E3%83%94/%E3%81%AB%E3%82%93%E3%81%98%E3%82%93">にんじん</a> <a href="/%E3%83%AC%E3%82%B7%E3%83%94/%E7%B5%B9%E3%81%94%E3%81%97%E8%B1%86%E8%85%90">絹ごし豆腐</a> <a href="/%E3%83%AC%E3%82%B7%E3%83%94/%E8%B1%9A%E3%83%90%E3%83%A9%E3%82%B9%E3%83%A9%E3%82%A4%E3%82%B9">豚バラスライス</a> <a href="/%E3%83%AC%E3%82%B7%E3%83%94/%E5%8D%B5">卵</a> <a href="/%E3%83%AC%E3%82%B7%E3%83%94/%E9%86%A4%E6%B2%B9">醤油</a> <a href="/%E3%83%AC%E3%82%B7%E3%83%94/%E5%A1%A9">塩</a>
    </div>
  </div>

  </div>
  
  
</div>



<!--kinmugi企画用-->










<div class="extension ext_aloha_open_graph_ext ext_aloha_open_graph_ext-log_facebook_user_status"><script>
  //<![CDATA[
    jQuery(function($) {
      $(document).bind('facebook:ready', function() {
        FB.getLoginStatus(function(response) {
          if (response.status == 'connected' || response.status == 'not_authorized') {
            _gaq.push(["_trackEvent", 'FacebookUser', 'view', ""]);
          }
        });
      });
    });
  //]]>
</script>

</div>

            <div class="clear"></div>

              <div id="main-cont-bottom-650"></div>
          </div>

          
          <div id="side">
  
  
  
  
  
  
  
  <div id='async-view-from_search_engine_ext' class='partial-async-view partial-async-view-hidden'></div>
  
  
  
  
  <div id="ad">
    <div id="log_wrapper"></div>
      <!-- トップ -->
        
          <div class="side_banner_wrapper">
            <!-- 500万impプロパネ -->
            <div id="500_panel"></div>

            <!-- 300万impプロパネ -->
            <div id="300_panel"></div>

            <!-- 150万impプロパネ -->
            <div id="150_panel"></div>

            <!--検索連動バナー-->
              <div id="search_banner"></div>



            <div id="cook_tv_banner"></div>

            <div id="selected_user_ad"></div>
          </div>

          <div class="side_banner_wrapper">
            <div class='style_4' id='new_text_tieup_wrapper'>
<h2 class='nt_content_title'>
毎週更新！おすすめレシピ特集
<img alt="Pr" src="/images/themes/top/wadai/pr.gif?1318414277" />
<div class='link_to_list'>
<a href="http://cookpad.com/ct/45214">一覧はこちら</a>
</div>
</h2>
<div class='tieup_list'>
<div id="tieup_list_content"></div>
<div class='link_to_event'>
<a href="http://cookpad.com/ct/43092">もっと見る</a>
</div>
</div>
</div>

          </div>
          <div class="side_banner_wrapper">
            <div id="sponsored_trend_keywords"></div>
          </div>
          <div class="side_banner_wrapper">
            <div id="introduce_enquete"></div>
          </div>
          <div class="side_banner_wrapper">
            <div id="ad_right_down_image"></div>
          </div>
          <div id="g_ad" class="side_banner_wrapper">
            <div id="ad_right_down_text"></div>
          </div>

      <!-- /if top -->
<!-- /unless no_default_ad -->
  </div>





<div id="ltp"></div>
</div>



          <div style="clear:both;"></div>
          
            

        </div><!--/content-->

        
          

  <div class="ad_bottom_banner">

    <div id="footer_txt_banner"></div>
    <div id="cpc_footer_banner"></div>

    <div id="adsense_bottom" class="hidden" >
      <style type="text/css">
<!--

#adsense_goiken_fukidashi {
  background: url('/images/shared/ad_goiken_back_fukidashi.gif') no-repeat;
  height: 10px;
  width: 270px;
  font-size: 0px;
}

#adsense_goiken_whole_wrapper {
  width: 450px;
  margin: 0px auto;
}

#adsense_goiken_link_text:link {
  text-decoration: none;
}
#adsense_goiken_link_text:visited {
  text-decoration: none;
}
#adsense_goiken_link_text:hover {
  text-decoration: underline;
}

#adsense_goiken_question_wrapper{

}
#adsense_goiken_question_wrapper a{
  font-size: 85%;
  color: #999999;
  text-decoration: none;
}
#adsense_goiken_body_wrapper{
  width: 450px;
  border: 1px solid #B7C5D8;
  background-color: #FFFFFF;
}
#adsense_goiken_title_wrapper {
  background: #B7C5D8;
  padding: 5px 10px;

}
#adsense_goiken_title{
  font-weight: bold;
  color: #FFFFFF;
  font-size: 85%;

}
#adsense_goiken_wrapper{
  padding: 0px;
}
#adsense_goiken_message{
  width: 276px;
  height: 70px;
}
#adsense_goiken_submit_wrapper{
  text-align: center;
  padding: 5px;
  margin-bottom: 5px;
}
#adsense_goiken_message2_wrapper{
  padding-bottom: 5px;
  font-size: 85%;
}
#adsense_goiken_close_link a:link {
  color: #999;
  text-decoration: none;
}
#adsense_goiken_close_link a:visited {
  color: #999;
  text-decoration: none;
}
#adsense_goiken_close_link a:hover {
  color: #999;
  text-decoration: underline;
}
input.adsense_goiken_message2 {
margin-right: 4px;
}

#star_wrapper_adsense,
#text_star_wrapper_adsense {
  width: 72px;
  height: 16px;
  background: url('/images/shared/ad_goiken_stars.gif') no-repeat top;
  margin-top: 10px;
  margin-bottom: 5px;
  overflow: hidden;
}

#star_wrapper_adsense {
 float: left;
}

#adsense_star0 {
  display: block;
  float: left;
  width: 10px;
  height: 26px;
}

a.adsense_goiken_star,
a.adsense_goiken_text_star {
  display: block;
  float: left;
  width: 18px;
  height: 16px;
}

#adsense_goiken_link_text_wrapper {
  /*font-size: 13px;*/
  /*float: left;*/
  /*margin-left: 40px;*/
  /*_margin-left: 25px;*/
  text-align: center;
}

textarea.textarea {
  margin-left: 10px;
}

#adsense_goiken_message {
  margin-left: 0px !important;
}


-->
</style>

<div id="adsense_goiken_question_wrapper" style="margin-top: 2px;">
  <div id="adsense_goiken_link_text_wrapper">
    <a href="javascript:void 0" id="adsense_goiken_link_text" >この広告を評価してください</a>
  </div>
</div>
<div id="adsense_goiken_whole_wrapper" style="display: none; margin-top: 5px;">
  <div id="adsense_goiken_fukidashi">&nbsp;</div>
  <div id="adsense_goiken_body_wrapper">
    <div class="separate_wrapper" id="adsense_goiken_title_wrapper">
      <div id="adsense_goiken_title">
        この広告を評価してください&nbsp;
      </div>
      <div id="adsense_goiken_close_link" class="separate_right" style="top: 0px; padding-right: 10px;">
        <a href="#" onclick="jQuery('#adsense_goiken_whole_wrapper').hide(); jQuery('#adsense_goiken_question_wrapper').show();; return false;">×</a>
      </div>
    </div>
    <div id="adsense_goiken_wrapper">
      <span id="adsense_star0"></span>
      <div id="star_wrapper_adsense">
        <a href="javascript:void 0" class="adsense_goiken_star star1" id="adsense_star1" ></a>
        <a href="javascript:void 0" class="adsense_goiken_star star2" id="adsense_star2" ></a>
        <a href="javascript:void 0" class="adsense_goiken_star star3" id="adsense_star3" ></a>
        <a href="javascript:void 0" class="adsense_goiken_star star4" id="adsense_star4" ></a>
      </div>
      <form accept-charset="UTF-8" action="/goiken/ad_post?update=adsense_goiken_wrapper" class="cp_form" data-remote="true" id="new_ad_goiken" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input id="token" name="token" type="hidden" value="c89f9f4ef264e22001f9a9c3d72992ef" /></div>      <input id="adsense_goiken_network_ad_content" name="ad_goiken[network_ad_content]" type="hidden" />
      <input id="ad_goiken_product_id" name="ad_goiken[product_id]" type="hidden" value="0" />
      <input id="ad_goiken_campaign_id" name="ad_goiken[campaign_id]" type="hidden" value="0" />
      <input id="ad_goiken_creative_id" name="ad_goiken[creative_id]" type="hidden" value="9071" />
      <input id="adsense_goiken_rate" name="ad_goiken[rate]" type="hidden" value="0" />
      <textarea class="textarea" cols="40" id="adsense_goiken_message" name="ad_goiken[message]" rows="20" style="color: #999999; width: 420px; height: 37px;"></textarea>
      <div id="adsense_goiken_submit_wrapper">
        <input id="adsense_goiken_submit" name="commit" type="submit" value="クックパッドに送る" />
      </div>
      <div class="clear"></div>
</form>

      <script type="text/javascript">
//<![CDATA[



var focused_flag_adsense = false;
var adsense_message_box = jQuery('#adsense_goiken_message')[0];
var adsense_message = 'あなたの評価を教えてください。';
adsense_message_box.value = adsense_message;


jQuery('#adsense_goiken_link_text').click(function(){
  lock = false;
  jQuery('#adsense_goiken_question_wrapper').hide();
  jQuery('#adsense_goiken_whole_wrapper').show();
});


jQuery(adsense_message_box).focus(function(){
  if(!focused_flag_adsense){
    focused_flag_adsense = true;
    adsense_message_box.value = '';
    adsense_message_box.style.color = '#000000';

  }
});
jQuery(adsense_message_box).blur(function(){
  if(/^[\s　]*$/.test(adsense_message_box.value)){
    focused_flag_adsense = false;
    adsense_message_box.value = adsense_message;
    adsense_message_box.style.color = '#999999';
  }
});

var adsense_submit_button = jQuery('#adsense_goiken_submit')[0];
jQuery(adsense_submit_button).disable();

jQuery('#ad_goiken_message').focus(function(){
  jQuery(adsense_submit_button).enable();
});
jQuery('#star_wrapper_adsense').mouseover(function(){
  jQuery(adsense_submit_button).enable();
});

var lock = false;
jQuery('a.adsense_goiken_text_star').each(function(i, e){
  jQuery(e).click(function(){
      lock = false;
      jQuery('#adsense_goiken_question_wrapper').hide();
      jQuery('#adsense_goiken_whole_wrapper').show();

  });
});

jQuery('#adsense_star0').mouseover(function(){
      if (lock) {return false;};
      jQuery('#star_wrapper_adsense')[0].style.backgroundPosition = '0px 0px';
      jQuery('#adsense_goiken_rate')[0].value = '0';
});

jQuery('#adsense_star1').mouseover(function(){
      if(lock){return false;};
      jQuery('#star_wrapper_adsense')[0].style.backgroundPosition='0px -16px';
      jQuery('#adsense_goiken_rate')[0].value = '1';
});

jQuery('adsense_star2').mouseover(function(){
      if(lock){return false;};
      jQuery('#star_wrapper_adsense')[0].style.backgroundPosition='0px -32px';
      jQuery('#adsense_goiken_rate')[0].value = '2';
});

jQuery('#adsense_star3').mouseover(function(){
      if(lock){return false;};
      jQuery('#star_wrapper_adsense')[0].style.backgroundPosition='0px -48px';
      jQuery('#adsense_goiken_rate')[0].value = '3';
});

jQuery('#adsense_star4').mouseover(function(){
      if(lock){return false;};
      jQuery('#star_wrapper_adsense')[0].style.backgroundPosition='0px -64px';
      jQuery('#adsense_goiken_rate')[0].value='4';
});

jQuery('#star_wrapper_adsense').click(function(){
      lock = true;

      var iframe = jQuery(window.frames["aswift_1"].document).find("iframe");
      jQuery('#adsense_goiken_network_ad_content')[0].value = [
         'iframe',
         iframe && iframe.attr("src"),
      ].join('#');
});

//]]>
</script>
    </div>
  </div>
</div>

    </div>
  </div>


      </div><!--container-->
    </div><!--/wrapper-->

    <div id='rich_footer_ext'>
<div id='rich_footer_wrapper'>
<div id='rich_footer_inner'>
<div id='rich_footer'>
<div id='footer_content_wrapper'>
<div class='footer_content footer_content_first'>
<div class='footer_content_title'>
クックパッド
</div>
<ul class='footer_content_list'>
<li>
<a href="/about/ps">プレミアムサービス</a>
</li>
<li>
<a href="/mobile">モバイルサービス</a>
</li>
<li>
<a href="/melmaga">メールマガジン</a>
</li>
<li>
<a href="/recipe/recent">新着レシピ</a>
</li>
<li>
<a href="/tsukurepo/recent">新着つくれぽ</a>
</li>
</ul>
<div class='footer_content_title related_service'>
<span style='font-size: 93%; font-weight: normal; padding-left: 0px;'>
地域限定
</span>
</div>
<ul class='footer_content_list'>
<li>
<a href="https://shop.cookpad.com" target="_blank">やさい便</a>
</li>
<li>
<a href="http://www.cookstep.jp" target="_blank">鎌倉の料理教室</a>
</li>
</ul>
</div>
<div class='footer_content'>
<div class='footer_content_title'>
サポート
</div>
<ul class='footer_content_list'>
<li>
<a href="http://cookpad.typepad.jp/help/" target="_blank;">ヘルプ</a>
</li>
<li>
<a href="https://cookpad.com/contact">お問い合わせ</a>
</li>
<li>
<a href="/info/faq">お料理を楽しむにあたって</a>
</li>
<li>
<a href="/terms/free">利用規約</a>
</li>
<li>
<a href="/info/link">リンクについて</a>
</li>
</ul>
<div class='footer_content_title company_info'>
企業情報
</div>
<ul class='footer_content_list'>
<li>
<a href="http://info.cookpad.com/" target="blank">運営会社</a>
</li>
<li>
<a href="/terms/privacy">個人情報保護方針</a>
</li>
<li>
<a href="http://info.cookpad.com/ir" target="blank">投資家向け情報</a>
</li>
<li>
<a href="http://info.cookpad.com/ads" target="blank">広告掲載</a>
</li>
<li>
<a href="http://info.cookpad.com/jobs/" target="blank">採用情報</a>
</li>
</ul>
</div>
<div class='footer_content' id='top_information'>
<div class='footer_content_title'>
お知らせ
</div>
<ul class='footer_content_list'>
<li class='without_list_style'>
<span class='release_date'>
12/02/23
</span>
<div class='link_to_info'>
<a href="http://cookpad.typepad.jp/help/2012/02/23oshirase.html" target="_blank">【Android クックパッドアプリご利用の方へ】最新版への更新のお願い</a>
</div>
</li>
<li class='without_list_style'>
<span class='release_date'>
12/02/23
</span>
<div class='link_to_info'>
<a href="http://www.ntv.co.jp/zip/" target="_blank">日本テレビ「ZIP！」でクックパッドが紹介されました</a>
</div>
</li>
<li class='without_list_style'>
<span class='release_date'>
12/02/23
</span>
<div class='link_to_info'>
<a href="http://info.cookpad.com/recipes" target="_blank">番組で紹介された塩麹を使ったレシピはこちら</a>
</div>
</li>
<li class='without_list_style'>
<span class='release_date'>
12/02/02
</span>
<div class='link_to_info'>
<a href="http://www.tv-asahi.co.jp/densetsu/" target="_blank">テレビ朝日「いきなり！黄金伝説。」でクックパッドが紹介されました</a>
</div>
</li>
</ul>
<div class='link_to_top_informations clear'>
<a href="http://info.cookpad.com/press" target="_blank">もっと見る</a>
</div>
</div>
<div class='goiken_outer'>
<div class='footer_content footer_goiken_wrapper'>
<div class='goiken_form'>
<p class='goiken_title'>
クックパッドについて
<br>あなたのご意見をお聞かせください</br>
</p>
<form accept-charset="UTF-8" action="/goiken/create" class="new_goiken" data-remote="true" id="new_goiken" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input id="token" name="token" type="hidden" value="c89f9f4ef264e22001f9a9c3d72992ef" /></div>
<input id="goiken_origin" name="goiken[origin]" type="hidden" value="1" />
<textarea class="textarea" cols="40" id="goiken" name="goiken[message]" rows="20"></textarea>
<div class='submit_wrapper'>
<input name="commit" type="submit" value="クックパッドに意見を送る" />
</div>
<p class='link_to_inq'>
<a href="http://cookpad.com/contact">使い方に関する質問、お問い合わせはこちら</a>
</p>
</form>
</div>
</div>
</div>
<div class='clear'></div>
</div>
<div id='copyright'>

<div class='site_copy_wrapper'>
<h2 class='site_copy'>
毎日の料理を楽しみに
<span>クックパッド</span>
</h2>
</div>
Copyright© COOKPAD Inc. All Rights Reserved
</div>
<div id='switch_smart_phone_view_wrapper'>
<div style='text-align:center; padding:5px; margin:25px 200px; font-weight:bold; background:white'>
<a href="/recipe/117485" class="sb_version_link_bnt">スマートフォン版に切り替え</a>
<script>
  //<![CDATA[
    (function ($) {
      function eraseCookie(name) {
        var date = new Date();
        date.setTime(date.getTime()+(-1*24*60*60*1000));
        var expires = '; expires='+date.toGMTString();
    
        document.cookie = name+'='+expires+'; path=/';
      }
    
      $('.sb_version_link_bnt').bind('click', function (event) {
        eraseCookie('device');
        window.location.reload();
        event.preventDefault();
        event.stopPropagation();
      });
    })(jQuery);
  //]]>
</script>
</div>
</div>
</div>
</div>
</div>
</div>
<div class='clear'></div>


    
    

    <div id='async-view-staff_footer' class='partial-async-view partial-async-view-hidden'></div>

    <script type="text/javascript">
//<![CDATA[
window.replace_tags && replace_tags();
//]]>
</script>
    

    
    <div class='myfolder_add_capacity' id='myfolder_alert_balloon'>
<div class='myfolder_add_capacity notification_available_count'>
<div class='header'>
<p>
<a href="#" class="link_to_close_tip"></a>
</p>
</div>
<div class='content'>
<p class='content_text'></p>
<p class='navi_to_announce'>
<a href="/myfolder/announce_to_unlock_limit?type=limit" class="announce_to_unlock_limit">もっと追加するには?</a>
</p>
</div>
</div>
</div>

    <div id='search_autocomplete' class='autocomplete_container'></div>

    
  </body>
</html>
