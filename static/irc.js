var channels = {
   general:      {title:"General Perl Help",             host:"irc.freenode.net", channel:"perl"},
   win32:        {title:"Win32 specific",                host:"irc.perl.org",     channel:"win32"},
   padre:        {title:"Padre, the Perl IDE",           host:"irc.perl.org",     channel:"padre"},
   catalyst:     {title:"Catalyst",                      host:"irc.perl.org",     channel:"catalyst"},
   dbix_class:   {title:"DBIx::Class",                   host:"irc.perl.org",     channel:"dbix-class"},
   email:        {title:"Perl Email Project",            host:"irc.perl.org",     channel:"email"},
   parrot:       {title:"Parrot",                        host:"irc.perl.org",     channel:"parrot"},
   perl_qa:      {title:"Perl Quality Assurance",        host:"irc.perl.org",     channel:"perl-qa"},
   locale_fr:    {title:"Perl in French",                host:"irc.perl.org",     channel:"perlfr"},
   locale_it:    {title:"Perl in Italian",               host:"irc.freenode.net", channel:"perl.it"},
   locale_jp:    {title:"Perl in Japanese",              host:"irc.freenode.net", channel:"jpa-perl"},
   locale_kr:    {title:"Perl in Korean",                host:"irc.freenode.net", channel:"perl-kr"},
   locale_pl:    {title:"Perl in Polish",                host:"irc.perl.org",     channel:"perl.pl"},
   locale_pt_br: {title:"Perl in Portuguese",            host:"irc.freenode.net", channel:"perl.br"},
   locale_zh_tw: {title:"Perl in Taiwan (Traditional Chinese)", host:"irc.freenode.net", channel:"perl.tw"},
   poe:          {title:"POE",                           host:"irc.perl.org",     channel:"poe"},
   rt:           {title:"RT",                            host:"irc.perl.org",     channel:"rt"},
   perl_help:    {title:"Perl Help",                     host:"irc.perl.org",     channel:"perl-help"},
   wxperl:       {title:"Wx Perl",                       host:"irc.perl.org",     channel:"wxperl"},
   perl6:        {title:"Perl 6 development",            host:"irc.freenode.net", channel:"perl6"},
};
var default_channel = "general";

function get_values() {
    // getting the parameters from the URL
    var loc = window.location.toString().indexOf('?');
    if (loc > 0) {
        var val = window.location.toString().substr(loc + 1);
        var pairs = val.split("&");
        var data = Array;
        for (var i = 0; i < pairs.length; i++) {
	    var pair = pairs[i].split("=");
	    data[pair[0]] = pair[1];
        }
        return data;
    } else {
        return [];
    }
}

function on_click() {

    var name;
    for (var i = 0; i < document.forms.n.channel.length; i++) {
	if (document.forms.n.channel[i].checked) {
	    name = document.forms.n.channel[i].value;
	}
    }
    
    var url;
    if (channels[name].host == 'irc.freenode.net') {
	url =  'http://webchat.freenode.net/?';
	url += 'channels=' + channels[name].channel;
	url += '&nick=' + document.forms.n.nickname.value;
    } else {
	url = 'http://widget.mibbit.com/?autoConnect=true';
	url += '&server=' + channels[name].host;
	url += '&channel=%23' + channels[name].channel;
	url += '&nick=' + document.forms.n.nickname.value;
    }
    //alert(url);
    window.location = url;
}

function setup_page() {
    var values = get_values();
    if (values["nickname"]) {
	document.forms.n.nickname.value = values["nickname"];
    } else if (getCookie('nickname')) {
	    document.forms.n.nickname.value = getCookie('nickname');
	} else {
	var nick = Math.floor(Math.random()*10000);
	document.forms.n.nickname.value = "user_" + nick;
    }
    var ch = default_channel;
    if (values["channel"]) {
	if (channels[ values["channel"] ]) {
	    ch = values["channel"];
	}
    }

    for (var i in channels) {
	var html = '<tr><td><input type="radio" name="channel" value="' + i + '"';
	if (i == ch) {
	    html += " CHECKED ";
	}
	html    += '>' + channels[i].title + '</td></tr>';
	document.write(html);
    }
}



var channels = {
   general:      {title:"General Perl Help",             host:"irc.freenode.net", channel:"perl"},
   win32:        {title:"Win32 specific",                host:"irc.perl.org",     channel:"win32"},
   padre:        {title:"Padre, the Perl IDE",           host:"irc.perl.org",     channel:"padre"},
   catalyst:     {title:"Catalyst",                      host:"irc.perl.org",     channel:"catalyst"},
   dbix_class:   {title:"DBIx::Class",                   host:"irc.perl.org",     channel:"dbix-class"},
   email:        {title:"Perl Email Project",            host:"irc.perl.org",     channel:"email"},
   parrot:       {title:"Parrot",                        host:"irc.perl.org",     channel:"parrot"},
   perl_qa:      {title:"Perl Quality Assurance",        host:"irc.perl.org",     channel:"perl-qa"},
   locale_fr:    {title:"Perl in French",                host:"irc.perl.org",     channel:"perlfr"},
   locale_it:    {title:"Perl in Italian",               host:"irc.freenode.net", channel:"perl.it"},
   locale_jp:    {title:"Perl in Japanese",              host:"irc.freenode.net", channel:"jpa-perl"},
   locale_kr:    {title:"Perl in Korean",                host:"irc.freenode.net", channel:"perl-kr"},
   locale_pl:    {title:"Perl in Polish",                host:"irc.perl.org",     channel:"perl.pl"},
   locale_pt_br: {title:"Perl in Portuguese",            host:"irc.freenode.net", channel:"perl.br"},
   locale_zh_tw: {title:"Perl in Taiwan (Traditional Chinese)", host:"irc.freenode.net", channel:"perl.tw"},
   poe:          {title:"POE",                           host:"irc.perl.org",     channel:"poe"},
   rt:           {title:"RT",                            host:"irc.perl.org",     channel:"rt"},
   perl_help:    {title:"Perl Help",                     host:"irc.perl.org",     channel:"perl-help"},
   wxperl:       {title:"Wx Perl",                       host:"irc.perl.org",     channel:"wxperl"},
   perl6:        {title:"Perl 6 development",            host:"irc.freenode.net", channel:"perl6"},
};
var default_channel = "general";

function get_values() {
    // getting the parameters from the URL
    var loc = window.location.toString().indexOf('?');
    if (loc > 0) {
        var val = window.location.toString().substr(loc + 1);
        var pairs = val.split("&");
        var data = Array;
        for (var i = 0; i < pairs.length; i++) {
	    var pair = pairs[i].split("=");
	    data[pair[0]] = pair[1];
        }
        return data;
    } else {
        return [];
    }
}

function on_click() {

    var name;
    for (var i = 0; i < document.forms.n.channel.length; i++) {
	if (document.forms.n.channel[i].checked) {
	    name = document.forms.n.channel[i].value;
	}
    }
    document.setcookie
    var url;
    if (channels[name].host == 'irc.freenode.net') {
	url =  'http://webchat.freenode.net/?';
	url += 'channels=' + channels[name].channel;
	url += '&nick=' + document.forms.n.nickname.value;
    } else {
	url = 'http://widget.mibbit.com/?autoConnect=true';
	url += '&server=' + channels[name].host;
	url += '&channel=%23' + channels[name].channel;
	url += '&nick=' + document.forms.n.nickname.value;
    }
    //alert(url);
    window.location = url;
}

function setup_page() {
    var values = get_values();
    if (values["nickname"]) {
	document.forms.n.nickname.value = values["nickname"];
    } else {
	var nick = Math.floor(Math.random()*10000);
	document.forms.n.nickname.value = "user_" + nick;
    }
    var ch = default_channel;
    if (values["channel"]) {
	if (channels[ values["channel"] ]) {
	    ch = values["channel"];
	}
    }

    for (var i in channels) {
	var html = '<tr><td><input type="radio" name="channel" value="' + i + '"';
	if (i == ch) {
	    html += " CHECKED ";
	}
	html    += '>' + channels[i].title + '</td></tr>';
	document.write(html);
    }
}

</script>