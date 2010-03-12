//$(document).ready(start_editor);

function add_comments_to(div_id, post_id){
  var skin = {};
  skin['FONT_FAMILY']                  = 'verdana,sans-serif';
  skin['BORDER_COLOR']                 = '#cccccc';
  skin['ENDCAP_BG_COLOR']              = '#ffffff';
  skin['ENDCAP_TEXT_COLOR']            = '#333333';
  skin['ENDCAP_LINK_COLOR']            = '#e44817';
  skin['ALTERNATE_BG_COLOR']           = '#ffffff';
  skin['CONTENT_BG_COLOR']             = '#ffffff';
  skin['CONTENT_LINK_COLOR']           = '#e44817';
  skin['CONTENT_TEXT_COLOR']           = '#333333';
  skin['CONTENT_SECONDARY_LINK_COLOR'] = '#ff6600';
  skin['CONTENT_SECONDARY_TEXT_COLOR'] = '#666666';
  skin['CONTENT_HEADLINE_COLOR']       = '#333333';
  skin['DEFAULT_COMMENT_TEXT']         = '- escreve aqui o teu coment\xe1rio -';
  skin['HEADER_TEXT']                  = 'Coment\xe1rios';
  skin['POSTS_PER_PAGE']               = '5';
  google.friendconnect.container.setParentUrl('/' /* location of rpc_relay.html and canvas.html */);
  google.friendconnect.container.renderWallGadget({ 
    id: div_id, 
    site: '08500384118521227158',
    'view-params': {
      "disableMinMax":"true",
      "scope":"ID",
      "features":"video,comment",
      "docId":post_id,
      "startMaximized":"true"
    }
  },skin);
  void 0
}


function add_adsense_to(div_id){
  var skin = {};
  skin['HEIGHT'] = '90';
  skin['BORDER_COLOR'] = 'transparent';
  skin['ENDCAP_BG_COLOR'] = '#e0ecff';
  skin['ENDCAP_TEXT_COLOR'] = '#333333';
  skin['ENDCAP_LINK_COLOR'] = '#e44817';
  skin['ALTERNATE_BG_COLOR'] = '#ffffff';
  skin['CONTENT_BG_COLOR'] = '#ffffff';
  skin['CONTENT_LINK_COLOR'] = '#e44817';
  skin['CONTENT_TEXT_COLOR'] = '#333333';
  skin['CONTENT_SECONDARY_LINK_COLOR'] = '#e44817';
  skin['CONTENT_SECONDARY_TEXT_COLOR'] = '#666666';
  skin['CONTENT_HEADLINE_COLOR'] = '#333333';
  google.friendconnect.container.setParentUrl('/' /* location of rpc_relay.html and canvas.html */);
  google.friendconnect.container.renderAdsGadget({
    id: div_id,
    height: 90,
    site: '08500384118521227158',
    'prefs':{
      "google_ad_client":"ca-pub-8099100965078954",
      "google_ad_host":"pub-6518359383560662",
      "google_ad_format":"728x90"
    }
  },skin);
  void 0
}

