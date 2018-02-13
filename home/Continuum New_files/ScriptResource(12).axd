var version = '1.0.0';

// Avoid `console` errors in browsers that lack a console.
(function () {
    var method;
    var noop = function () { };
    var methods = [
        'assert', 'clear', 'count', 'debug', 'dir', 'dirxml', 'error',
        'exception', 'group', 'groupCollapsed', 'groupEnd', 'info', 'log',
        'markTimeline', 'profile', 'profileEnd', 'table', 'time', 'timeEnd',
        'timeline', 'timelineEnd', 'timeStamp', 'trace', 'warn'
    ];
    var length = methods.length;
    var console = (window.console = window.console || {});

    while (length--) {
        method = methods[length];

        // Only stub undefined methods.
        if (!console[method]) {
            console[method] = noop;
        }
    }
}());



(function ($) {
    var methods = ['addClass', 'toggleClass', 'removeClass'];

    $.each(methods, function (index, method) {
        var originalMethod = $.fn[method];

        $.fn[method] = function () {
            try {


                var oldClass = this[0].className;
                var result = originalMethod.apply(this, arguments);
                var newClass = this[0].className;

                this.trigger(method, [oldClass, newClass]);

                return result;

            } catch (e) {
                return this;
            }
        };
    });
}(window.jQuery || window.Zepto));






// Responsive Utils
var $xsMin= 480;
var $smMin =  768;
var $mdMin = 992;
var $lgMin = 1200;

var viewportWith = function() {
    var viewportWidth = $(window).width();

    $(window).resize(function () {
        viewportWidth = $(window).width();
    });

    return viewportWidth;
}







// Patch for adding .browser legacy support
// The jQuery.browser() method has been deprecated since jQuery 1.3 and is removed in 1.9. If needed, it is available as part of the jQuery Migrate plugin. We recommend using feature detection with a library such as Modernizr.
$.browser = {};
(function () {
    $.browser.msie = false;
    $.browser.version = 0;
    if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
        $.browser.msie = true;
        $.browser.version = RegExp.$1;
    }
})();

//prevent autozooming on focus inputs, selects and textareas
; (function () {
    'use strict';

    $(function () {
        $('input, select, textarea')
            .bind('focus blur', function (event) {
                var eventType = (event || {}).type,
                    $viewportMetaTag = $('meta[name="viewport"]');

                if ($viewportMetaTag) {
                    $viewportMetaTag.attr('content', 'width=device-width,initial-scale=1,maximum-scale=' + (eventType === 'blur' ? 10 : 1));
                }
            });
    });
}());


// Hot fix of incorrect links -->
$(function () {
    if (window.location.href.indexOf('://journals.lww.com') > 0) {
        $('#main-footer .footer-links a').each(function (index, jLink) {
            var fixedHref = jLink.href.replace('://journals.na.lww.com', '://journals.lww.com');
            jLink.href = fixedHref;
        });
    }
});
// <-- Hot fix of incorrect links

$(function () {
    // Prepares SharePoint menu for bootstrap
    sanitizeSharePointMenu();
    modyfyExternalHyperlinks();
    swapFaviconsIEOnly();
    // Hamburger menu icon click
    var isFatJuicyOpen = false;
    $('#fatJuicy').click(function () {
        if (isFatJuicyOpen) {
            switchNavBorder(false);
            isFatJuicyOpen = false;
        } else {
            switchNavBorder(true);
            isFatJuicyOpen = true;
        }        
    });

    // Load items
    switchContentBoxCollapsible();
    initSmallState();

    // Respond to viewport change
    var viewportSize = '';
    $(window).resize(function () {
        var currentResolution;

        if ($(window).width() > $lgMin) {
            currentResolution = 'large';
        } else if ($(window).width() > $mdMin) {
            currentResolution = 'medium';
        } else {
            currentResolution = 'small';
        }

        // Execute window resize stuff only once per resulution change
        if (viewportSize !== currentResolution) {

            // Not mobile
            if (viewportSize === 'medium' && currentResolution !== 'small') {
                $('#navActionButtons').removeAttr('style');
            }

            // Change from small to medium
            if (viewportSize === 'small' && currentResolution === 'medium') {
                // do some stuff
            }

            // Change from medium to small
            if (viewportSize === 'medium' && currentResolution === 'small') {
                initSmallState();
            }

            switchContentBoxCollapsible();

            // Assign viewport with new resolution
            viewportSize = currentResolution;
        }

    });

    // Add Main Navigation border bottom on hover
    $("ul[id$='RootAspMenu']").mouseover(function () {

        switchNavBorder(true);

    }).mouseout(function () {

        if (!$('li.dropdown').hasClass('open') && (viewportWith() >= $lgMin)) {
            switchNavBorder(false);
        }
    });

    // Removes Main Navigation border bottom when dropdown pop up is closed
    $('li.dropdown').on('addClass toggleClass removeClass', function (e, oldClass, newClass) {
        // console.log('Changed from %s to %s due %s', oldClass, newClass, e.type);

        if (e.type == "removeClass" && (viewportWith() >= $lgMin))
            switchNavBorder(false);


    });
    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function() {
        modyfyExternalHyperlinks();
    });
});


jQuery(window).load(function () {
    // Prepares Admin/NA site UI for optimun display 
    optimizeAdminUI();
});

function initSmallState() {
    if ($(window).width() < $mdMin) {
        // Collapse everything
        var contentBoxBody = $(".cb-collapsible > div.content-box-body");

        //change 115048                    
        $('.cb-collapsible > header > h2').attr('aria-expanded', true);
        contentBoxBody.attr('aria-expanded', true);
        contentBoxBody.show();

        collapseMobileArticleTools();
    }
}

function collapseMobileArticleTools() {
    var articleToolsBox = $("#mobileArticleTools > #wpArticleTools > div.content-box-body");
    $('#wpArticleTools.cb-collapsible > header > h2').attr('aria-expanded', false);
    articleToolsBox.attr('aria-expanded', false);
    articleToolsBox.hide();
}

function switchContentBoxCollapsible() {
    // Not mobile
    if ($(window).width() > $mdMin) {

        // Remove collapsing functionality for bigger resolutions
        $('.cb-collapsible > header > h2').unbind('click');
        $(".cb-collapsible > header > h2").removeAttr('aria-expanded');
        $("div.content-box-body").removeAttr('aria-expanded');
        $("div.content-box-body").show();
    }

    // Mobile
    if ($(window).width() < $mdMin) {
        // Toggle content box with "cb-collapsible" class
        // Ensures one click event instance
        $('.cb-collapsible > header > h2').unbind('click');
        $(".cb-collapsible > header > h2").click(function () {

            var contentBoxBody = $(this).parent('header').next("div.content-box-body");

            if (contentBoxBody.attr('aria-expanded') === 'false') {
                // Open current panel
                $(this).attr('aria-expanded', true);
                contentBoxBody.attr('aria-expanded', true);
                contentBoxBody.slideToggle(600);

            } else {
                // Close current panel
                $(this).attr('aria-expanded', false);
                contentBoxBody.attr('aria-expanded', false);
                contentBoxBody.slideToggle(600);

            }
        });
        initSmallState();
    }
}

function switchNavBorder(shouldAdd) {
    if (shouldAdd){
        $('.main-nav-hover-overlay').addClass('main-nav-hover-overlay-hover');
        $('#navActionButtons').css({ 'display': 'flex' });
    } else {
        $('.main-nav-hover-overlay').removeClass('main-nav-hover-overlay-hover');
        $('#navActionButtons').css({ 'display': 'none' });
    }
}

function sanitizeSharePointMenu() {

    // Sanitize Main container
    $('div[id$="TopNavigationMenu"]').removeClass('noindex ms-core-listMenu-horizontalBox');

    // Sanitize root menu items
    var rootMenu = $('ul[id$="RootAspMenu"]');
    rootMenu.removeClass('root ms-core-listMenu-root static').addClass('nav navbar-nav');
    rootMenu.children('li').removeClass('static');
    rootMenu.children('li.selected').removeClass('selected');//.addClass('active');

    if (rootMenu.children('li.dynamic-children').length) {
        rootMenu.children('li.dynamic-children').removeClass('dynamic-children').addClass('dropdown');
    }

    rootMenu.children('li > a').removeClass('static menu-item ms-core-listMenu-item ms-displayInline ms-navedit-linkNode');

    if (rootMenu.children('li.dropdown').length) {
        rootMenu.children('li.dropdown').children('ul.dynamic').removeClass('dynamic').addClass('dropdown-menu');
    }

    // Sanitize sub menu items
    rootMenu.children('li.dropdown').each(function () {
        var itemName = $(this).find('span.menu-item-text').html();
        $(this).children('a').replaceWith(' <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">' + itemName + '<i class="fa "></i></a>');
        $(this).children('span').replaceWith(' <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">' + itemName + '<i class="fa "></i></a>');
        if ($(this).children('a')) {
            $(this).children('a').attr("data-toggle", "dropdown");
        }
    });

    rootMenu.children('li.dynamic').removeClass('dynamic');

}

function optimizeAdminUI() {

    if ($('.ms-cui-tabContainer').length > 0) {

        // Push page container down when edit page ribbon is present
        $('div[id$="SharePointActionsContainer"]').css({ "min-height": "16rem" });

    }
};

function modyfyExternalHyperlinks() {
    var jrnl = _spPageContextInfo.siteServerRelativeUrl;
    var pattern = "^(http|https)://" + window.location.host.toLowerCase() + "(/_layouts/|/pages/|/secure/|" + jrnl + "/|" + jrnl + "#|"+ jrnl + "?)";
    var re = new RegExp(pattern, "i");

    function isExternal(link) {
        if (!link.host)
            return false;

        var match = re.test(link.href);
        return !match;
    }

    function setAttributes(link) {
        link.setAttribute('target', '_blank');
        link.setAttribute('rel', 'noopener');
    }

    var anchors = document.querySelectorAll("a");
    anchors = [].slice.call(anchors);

    anchors.forEach(function (link) {
        var external = isExternal(link);
        if (external) {
            setAttributes(link);
        }
    });
}

$(document).ready(function () {
    $(".dropdown-toggle").dropdown();
});

$(window).resize(function () {
    if ($(window).width() < $mdMin) {
        {
            $("#wpSubscriptionErrorMessage").insertBefore(".main-nav-hover-overlay");
        }
    }
});
$(document).ready(function () {
    $(".ej-session-expired-from-login").insertAfter("#main-nav");

    //breadcrumb fix
    if (document.URL.indexOf("/default.aspx") != -1 && document.URL.indexOf("/blog/") == -1) {
        $('div.main-content > div > div#breadcrumb').css('display', 'none');
        $('div.main-content > div.bread-crumb-padding > div > div#breadcrumb').css('display', 'none')
    } 

});

function swapFaviconsIEOnly() {
    //IE and Edge render first valid favicon as primary, if multiple favicons on the page.
    //Other browsers render last valid as primary.
    //Tricky fix: swap links for ie and edge only
    if (document.documentMode || /Edge/.test(navigator.userAgent)) {
        var favicons = document.querySelectorAll("head > link[id*='favicon']");
        if (favicons.length === 2) {
            var tmp = favicons[0].href;
            favicons[0].href = favicons[1].href;
            favicons[1].href = tmp;
        }
    }
}

// set color for ResentSearchContainer depends on li > a color
$(function () {
    var textColor = $('.dropdown-menu>li>a').css('color');
    $('#ResentSearchContainer').css('color', textColor);
});
function ejournals_pageLoad(sender, args)
{    
	$addHandler(document, "keydown", OnKeyPress_Popup);
	if(typeof initializeCheckboxes == 'function' && initializeCheckboxes != undefined)
	{
		initializeCheckboxes();
	}
}
function pageLoad(sender, args) {
    closePopups();
}   

function OnKeyPress_Popup(args)
{       
    if(args.keyCode == Sys.UI.Key.esc)
    {            
	   closePopups();
	   CloseSlideShow_ImageGallery();
	   Close_GroupPopups();
       Close_SSOandETOCEmailPopUp();
    }
}


function Close_SSOandETOCEmailPopUp()
{
  //Close Etoc Email to colleague Popup
  if (typeof closeeTOCWindow == 'function' && closeeTOCWindow !=undefined) {
     closeeTOCWindow();
    }

    //Close Single Sign On Confirmation Popup
  if (typeof sso_closeSsoConfirmationPopup == 'function' && sso_closeSsoConfirmationPopup !=undefined) {
     sso_closeSsoConfirmationPopup();
    }

    //Close Single Sign On Help text  Popup
  if (typeof sso_closeSsoPopup == 'function' && sso_closeSsoPopup !=undefined) {
     sso_closeSsoPopup();
    }
}

function Close_GroupPopups() {

	  //close EditGroupNamePopupControl
	  if (typeof closeEditGroupPopUp == 'function' && closeEditGroupPopUp != undefined) {
	      closeEditGroupPopUp();
	  }

	  //close GroupActionPopUpControl()
	  if (typeof closeGroupActionPopUp == 'function' && closeGroupActionPopUp != undefined) {
	      closeGroupActionPopUp();
	  }

	  //close InviteGroupUserPopupControl
	  if (typeof group_CloseInviteGroupUserPopup == 'function' && group_CloseInviteGroupUserPopup != undefined) {
	      group_CloseInviteGroupUserPopup();
	  }

	  if (typeof group_CloseAddUserPopup == 'function' && group_CloseAddUserPopup != undefined) {
	      group_CloseAddUserPopup();
	  }
	  
	 if (typeof group_NoTransactionClose == 'function' && group_NoTransactionClose != undefined) {
	      group_NoTransactionClose();
	  }
}

function CloseSlideShow_ImageGallery()
{
    //close ImageGallery Slide Show popup
    if (typeof HideSlideShow == 'function' && HideSlideShow != undefined) {
        HideSlideShow();
    }
    if (typeof Close_Popup == 'function' && Close_Popup != undefined) {
    
        Close_Popup();
    }
}

function closePopups() {

    //closeAddRemove channel Window
    var hiddenAddRemoveAllChannel = getDotNetCtrl('hiddenAddRemoveAllChannel', 'input');
    if (hiddenAddRemoveAllChannel != null && hiddenAddRemoveAllChannel.value != 'True') {
        if (typeof closeAddRemoveWindow == 'function' && closeAddRemoveWindow != undefined) {
            closeAddRemoveWindow();
        }
    }
    else {
        hiddenAddRemoveAllChannel.value = 'false';
    }
    //close Remove Items popup
    var hiddenRemoveItems = getDotNetCtrl('hiddenRemoveItems', 'input');
    if(hiddenRemoveItems != null && hiddenRemoveItems.value != 'true')
    {        
        if(typeof closeRemoveItemsWindow == 'function' && closeRemoveItemsWindow != undefined)
        {
            closeRemoveItemsWindow();          
        }
    }
    else
    {
        hiddenRemoveItems.value = 'false';
    }    
    
    //close Copy Items popup
    var hiddenCopyItems = getDotNetCtrl('hiddenCopyItems', 'input');
    if(hiddenCopyItems != null && hiddenCopyItems.value != 'true')
    {        
        if(typeof closeCopyItemsWindow == 'function' && closeCopyItemsWindow != undefined)
        {
            closeCopyItemsWindow();          
        }
    }
    else
    {
        hiddenCopyItems.value = 'false';
    }    
    
    //close Move Items popup
    var hiddenMoveItems = getDotNetCtrl('hiddenMoveItems', 'input');
    if(hiddenMoveItems != null && hiddenMoveItems.value != 'true')
    {        
        if(typeof closeMoveItemsWindow == 'function' && closeMoveItemsWindow != undefined)
        {
            closeMoveItemsWindow();          
        }
    }
    else
    {
        hiddenMoveItems.value = 'false';
    }    
    
    //close Delete Search Item popup
    var hiddenDeleteSearchItem = getDotNetCtrl('hiddenDeleteSearchItem', 'input');
    if(hiddenDeleteSearchItem != null && hiddenDeleteSearchItem.value != 'true')
    {        
        if(typeof closeDeleteSearchItemWindow == 'function' && closeDeleteSearchItemWindow != undefined)
        {
            closeDeleteSearchItemWindow();          
        }
    }
    else
    {
        hiddenDeleteSearchItem.value = 'false';
    }    
    
    //close Edit Search popup
    var hiddenEditSearch = getDotNetCtrl('hiddenEditSearch', 'input');
    if(hiddenEditSearch != null && hiddenEditSearch.value != 'true')
    {        
        if(typeof closeEditSearchWindow == 'function' && closeEditSearchWindow != undefined)
        {
            closeEditSearchWindow();          
        }
    }
    else
    {
        hiddenEditSearch.value = 'false';
    }   
    
    //close Add Collection popup
    var hiddenAddCollection = getDotNetCtrl('hiddenAddCollection', 'input');
    if(hiddenAddCollection != null && hiddenAddCollection.value != 'true')
    {        
        if(typeof closeAddWindow == 'function' && closeAddWindow != undefined)
        {
            closeAddWindow();          
        }
    }
    else
    {
        hiddenAddCollection.value = 'false';
    }    
    
    //close Edit Collection popup
    var hiddenEditCollection = getDotNetCtrl('hiddenEditCollection', 'input');
    if(hiddenEditCollection != null && hiddenEditCollection.value != 'true')
    {        
        if(typeof closeEditWindow == 'function' && closeEditWindow != undefined)
        {
            closeEditWindow();        
        }
    }
    else
    {
        hiddenEditCollection.value = 'false';
    }    
    
    //close Delete Collection popup
    var hiddenDeleteCollection = getDotNetCtrl('hiddenDeleteCollection', 'input')
    if(hiddenDeleteCollection != null && hiddenDeleteCollection.value != 'true')
    {
        if(typeof closeDeleteWindow == 'function' && closeDeleteWindow != undefined)
        {
            closeDeleteWindow();
        }
    }
    else
    {
        hiddenDeleteCollection.value = 'false';
    }
    
    //close email to colleage popups
    var hiddenEmailToColleague = getDotNetCtrl('hiddenEmailToColleague', 'input');	
	if(hiddenEmailToColleague != null)
	{    
	    if(hiddenEmailToColleague.value != 'true' && hiddenEmailToColleague.value != 'True')
	    {
	        if(typeof closeWindow =='function' &&  closeWindow != undefined) 
      	    {
	           closeWindow();
	        }
	    }
	    else
	    {
	        hiddenEmailToColleague.value = 'false';
	    }
	}
            
    //close Add to my collections popups
    var hiddenAddArticle = getMultipleControls('hiddenAddArticle', 'input');
    var addArticle = false;
    if(hiddenAddArticle != undefined && hiddenAddArticle != null)
    {        
        for(var i = 0; i < hiddenAddArticle.length; i++)
        {
            if(hiddenAddArticle[i] != undefined && hiddenAddArticle[i] != null && (hiddenAddArticle[i].value == 'true' || hiddenAddArticle[i].value == 'True'))
            {
                addArticle = true;
                hiddenAddArticle[i].value = 'false';
                break;
            }
        }
    }
    if(addArticle == false)
    {
       	var addToMyCollectionsControls = getMultipleControls('btnCancelAddToMyCollections', 'input');
	    if(addToMyCollectionsControls != null)
      	{
	        for(var i = 0; i < addToMyCollectionsControls.length; i++)
       	    {
              	if(addToMyCollectionsControls[i] != null && addToMyCollectionsControls[i] != undefined)
	            {
       	            addToMyCollectionsControls[i].click(); 
               	}
	         }
       	}	
        var addToMyCollectionsPopupMessage = getMultipleControls('btnCancelAddToMyCollectionsMessage', 'input');
        if(addToMyCollectionsPopupMessage != null)
        {
            for(var i = 0; i < addToMyCollectionsPopupMessage.length; i++)
            {
                if(addToMyCollectionsPopupMessage[i] != null && addToMyCollectionsPopupMessage[i] != undefined)
                {
                    addToMyCollectionsPopupMessage[i].click(); 
                 }
             }                    
         }
      }
      //close toc popups
      if (typeof getTocControl == 'function' && getTocControl != undefined) 
      {
          if (getTocControl() != null) {
              getTocControl().hide();
          }
      } 
      
            
      //close forgot password popups
      var hiddenForgotPassword = getDotNetCtrl('hiddenForgotPassword', 'input');
      if(hiddenForgotPassword != undefined && hiddenForgotPassword != null)
      {
        if(hiddenForgotPassword.value != 'true' && hiddenForgotPassword.value != 'True')
	    {
	        if (typeof fp_closeForgotPasswordPopup == 'function' && fp_closeForgotPasswordPopup!= undefined)
	        {
	            fp_closeForgotPasswordPopup();
	        }	
	    }
	    else
	    {
	        hiddenForgotPassword.value = 'false'
	    }
	  }
	  //close KeepMeLoggedIn Pop-up

	  if (typeof kml_closeKeepMeLoggedInPopup == 'function' && kml_closeKeepMeLoggedInPopup != undefined)
	  {
	      kml_closeKeepMeLoggedInPopup();
	  }

	  //close PersonalizedFeatures Popup
	  if (typeof kml_closePersonalizedFeaturesPopup == 'function' && kml_closePersonalizedFeaturesPopup != undefined) {
	      kml_closePersonalizedFeaturesPopup();
	  }
	  
	  //close Export selected popup
	  if(typeof closeExportToModalPopUp == 'function' && closeExportToModalPopUp != undefined)
	  {
	        closeExportToModalPopUp();
	  } 
	  
	  //close Save Search Popup
	  if(typeof closeSaveSearchPopup == 'function' && closeSaveSearchPopup != undefined)
	  {
	        closeSaveSearchPopup();
	  } 
	  
	  // hide out line pop up.
	  if(typeof hideOutline == 'function' && hideOutline != undefined)
	  {
	        hideOutline();
	  } 
	  
	  //close JournalsHierarchicalObjectPicker popup
	  if(typeof closeJournalsHierarchicalObjectPickerPopUp == 'function' && closeJournalsHierarchicalObjectPickerPopUp != undefined)
	  {
	        closeJournalsHierarchicalObjectPickerPopUp();
	  }
      
      //close JournalsHierarchicalObjectPicker popup
	  if(typeof closePAPHierarchicalObjectPickerPopUp == 'function' && closePAPHierarchicalObjectPickerPopUp != undefined)
	  {
	        closePAPHierarchicalObjectPickerPopUp();
	  }  
	  
	  //close ArticleAndImagePicker popup
	  if(typeof closeArticleAndImagePickerPopUp == 'function' && closeArticleAndImagePickerPopUp != undefined)
	  {
	        closeArticleAndImagePickerPopUp();
	  }

	  //close MagazineFeaturedArticlePopup
	  if (typeof closeMagazineFeaturedArticlePreview == 'function' && closeMagazineFeaturedArticlePreview != undefined) 
	  {
	      closeMagazineFeaturedArticlePreview();
	  }

	  //close blog Comment Preview
	  if (typeof closeCommentPreview == 'function' && closeCommentPreview != undefined) 
	  {
	      closeCommentPreview();
	  }

//	  //close alert subscription popups
//     if (typeof alerts_CloseSubscribeeTOCPopup == 'function' && alerts_CloseSubscribeeTOCPopup != undefined)
//	 {
//        alerts_CloseSubscribeeTOCPopup();
//	 }
  }   

function getMultipleControls(id,tag)
{
    var arObj = document.getElementsByTagName(tag);
	var serverCtrlName = id.replace('/_/g','$');
	var regExId = new RegExp(id+'$', 'ig');
	var controls = new Array(arObj.length);
	for (var i = 0; i < arObj.length; i++)
    {
	    if (arObj[i].id)
	    {
		    if (arObj[i].id.match(regExId))
		    controls[i] = arObj[i];
	    }
	    else if (arObj[i].name)
	    {
		    if (arObj[i].name == serverCtrlName)
		    controls[i] = arObj[i];
	    }
    }
	return controls;
}

function getDotNetCtrl(id,tag)
{
	var arObj = document.getElementsByTagName(tag);
	var serverCtrlName = id.replace('/_/g','$');
	var regExId = new RegExp(id+'$', 'ig');
	for (var i = 0; i < arObj.length; i++)
	{
		if (arObj[i].id)
		{
			if (arObj[i].id.match(regExId))
			return arObj[i];
		}
		else if (arObj[i].name)
		{
			if (arObj[i].name == serverCtrlName)
			return arObj[i];
		}
	}

	return false;
	
}   
    
    

function ReplaceAll(Source, stringToFind, stringToReplace) {
    var temp = Source;
    var index = temp.indexOf(stringToFind);
    while (index != -1) {
        temp = temp.replace(stringToFind, stringToReplace);
        index = temp.indexOf(stringToFind);
    }
    return temp;
}

//funcation to emit HTML
function Tooltip_HTML(heading, description) {
    ReplaceAll(heading, "<", "&lt;");
    ReplaceAll(heading, ">", "&gt;");
    ShowTooltip('<div id="box-modal-drop-shadow-hover"><div id="box-text-hover"><p><strong>' +
        heading +
        '</strong><br />' +
        description +
        '</p></div></div>');
}

function Tooltip_Actions() {
    Tooltip_HTML('Please Select Article(s)',
        'Choose an article(s) you wish to email a colleague, add to favorites, or export to citation manager');
}

function ShowTooltip(html) {
    Tip(html, BORDERWIDTH, 0, SHADOW, false, BGCOLOR, '', WIDTH, 0, FONTCOLOR, '#000000');
}

//Function to show tool-tip message for Buy icons
function Tooltip_Buy() {
    Tooltip_HTML('Purchase the article',
        'If you are not a subscriber, you may purchase this item with our pay-per-view service.');
}

function Tooltip_Buy_Collection() {
    Tooltip_HTML('Purchase the collection',
        'If you are not a subscriber, you may purchase this item with our pay-per-view service.');
}

//Function to show tool-tip message for Partial-Access icons
function Tooltip_Partial() {
    Tooltip_HTML('Partial access to the issue',
        'Some of the content within this issue is free. You do not need to be a subscriber to access free content.');
}

//Function to show tool-tip message for Free icons
function Tooltip_Free() {
    Tooltip_HTML('Free access', 'This item has free access. You do not need to be a subscriber to access this item.');
}

//Function to show tool-tip message for Open icons
function Tooltip_Open() {
    Tooltip_HTML('Open Access', 'This item is Open Access.');
}

//Function to show tool-tip message for SDC icons
function Tooltip_SDC() {
    Tooltip_HTML('Supplemental Digital Content',
        'This article contains supplemental content that can be downloaded by clicking a link in the full text.');
}

//Function to show tool-tip message for Online Only icons
function Tooltip_OnlineOnly() {
    Tooltip_HTML('Online only',
        'This item is only available online and cannot be found in any print issue of the journal.');
}

//Function to show tool-tip message for CE icons
function Tooltip_CE() {
    Tooltip_HTML('Continuing Education',
        'This item is accredited for continuing education. Please contact your society or state board for additional information.');
}

//Function to show tool-tip message for CME icons
function Tooltip_CME() {
    Tooltip_HTML('Continuing Medical Education',
        'This item is accredited for continuing medical education. Please contact your society or state board for additional information.');
}

//Function to show tool-tip message for PAP icons
function Tooltip_PAP(name, description) {
    Tooltip_HTML(name, description);
}

//Function to show tool-tip message for Errata icons
function Tooltip_Errata() {
    Tooltip_HTML('Errata', 'This article contains errata.');
}

//Function to show tool-tip message for Erratum icons
function Tooltip_Erratum() {
    Tooltip_HTML('Erratum', 'This article contains an erratum.');
}

//Function to show tool-tip message for Deep Archive icons
function Tooltip_DeepArchive() {
    Tooltip_HTML('Deep Archive', 'This is an archive item.');
}

//Function to show tool-tip message for Custom Indicator icons
function Tooltip_CustomIndicator(Custom_Indicator_Name, Custom_Indicator_Description) {
    Tooltip_HTML(findAndReplace(Custom_Indicator_Name), findAndReplace(Custom_Indicator_Description));
}

//Function to show tool-tip message for Video Gallery lock icon
function Tooltip_LOCK() {
    Tooltip_HTML('Locked Content', 'You do not have access to this content. Login or subscribe to view this content.');
}

//Function to show tool-tip message for RSS feed icon
function Tooltip_RSS() {
    Tooltip_HTML('RSS Feed', 'Subscribe to this feed to be notified of updates or changes to this content.');
}

//Function to hide/close the tool-tip message.
function Tooltip_MouseOut() {
    UnTip();
}

//Function to replace special char from inputstring incase of Custom indicators
function findAndReplace(indicator) {
    return indicator.replace(/&amp;/g, "&").replace(/&apos;/g, "\'");
}

//Function to show tool-tip message incase of Previous/Next article link, Title in Feature Article List control and title in Most popular article list control
function Tooltip_Article(title, author, journalName, year, volume, issue, pageRange) {
    ShowTooltip('<div id=box-modal-drop-shadow-hover><div id=box-text-hover><p><strong>' +
        title +
        '</strong><br />' +
        author +
        '<br />' +
        journalName +
        ' - ' +
        year +
        ' - Volume ' +
        volume +
        ' - Issue ' +
        issue +
        ' - pp ' +
        pageRange +
        '</p> </div></div>');
}

//Function to show tool-tip message incase of video title in most popular video list control
function Tooltip_Video(title, source, publishedOn, associatedWith, description) {
    if (associatedWith != null && associatedWith != '') {
        ShowTooltip('<div id="box-modal-drop-shadow-hover"><div id="box-text-hover"><p><strong>' +
            title +
            '</strong><br /><br /><strong>Author: </strong>' +
            source +
            '<br /><strong>Published on: </strong>' +
            publishedOn +
            '<br /><strong>Associated with: </strong><br />' +
            associatedWith +
            '<br />' +
            description +
            '</p></div></div>');
    }
    else {
        ShowTooltip('<div id="box-modal-drop-shadow-hover"><div id="box-text-hover"><p><strong>' +
            title +
            '</strong><br /><br /><strong>Author: </strong>' +
            source +
            '<br /><strong>Published on: </strong>' +
            publishedOn +
            '<br />' +
            description +
            '</p></div></div>');
    }
}

//Function to show tool-tip message incase of "Why do I not have access to the full-text?" on ArtcleViewerPage
function Tooltip_ArticleViewer() {
    ShowTooltip('<div id="box-modal-drop-shadow-hover"><div id="box-abstract-hover"><p><strong>You may need to</strong>:</p><ul><li>Login if you are a registered subscriber.</li><li>Register and activate your online subscription. </li><li>Subscribe to this Journal</li><li>Purchase access to this article if you are not a current subscriber.</li></ul><p><strong>Note</strong>: If your society membership provides for full-access to this article, you may need to login on your society\'s web site first.</p></div></div><div id="ej-clear-float"></div>');
}

//Function to show tool-tip message incase of "Alert Me When Cited" on ArtcleViewerPage
function Tooltip_CitedAlert() {
    ShowTooltip('<div id="box-modal-drop-shadow-hover"><div id="box-abstract-hover"><p>Receive an email alert every time this article is cited by another article.</p></div></div>');
}

//Function to show tool-tip message incase of Network Portfolio
function ToolTip_NetworkPortfolio(portfolioString) {
    ShowTooltip('<div id="box-modal-drop-shadow-hover"><div id="box-text-hover-02">' +
        portfolioString +
        '</div></div>');
}

//Function to show tool-tip message incase of "Highest Impacted Articles" on MostpopularWebpart
function Tooltip_HighestImpactedArticles() {
    ShowTooltip('<div id="box-modal-drop-shadow-hover"><div id="box-abstract-hover"><p>Generally, papers reach their citation peak two, three, or even four years after publication. A small group of papers, however, is recognized very soon after publication, reflected by rapid and significant numbers of citations. These papers are often key papers in their fields. We use a special filter to detect these hot papers and designate them as Highest Impact. This involves looking at recently published papers and unusual citation activity in a current time period. We also take into account the varying citation rates across fields.</p></div></div><div id="ej-clear-float"></div>');
}

//Function to show tool-tip message incase of "ePUB" on ArtcleViewerPage
function Tooltip_ePUB() {
    ShowTooltip('<div id="box-modal-drop-shadow-hover"><div id="box-abstract-hover"><p>Article format compatible with many eBook devices like Apple iPad&reg;, Sony eReader&reg;,  B&amp;N Nook&reg; and more…</p><p><strong>Note</strong>: iPad&reg; users, you will need to download and synchronize the EPUB file with iTunes&reg; in order to read the paper in iBooks&reg;.</p></div></div><div id="ej-clear-float"></div>');
}

//Function to show tool-tip message incase of "Readcube" on ArtcleViewerPage
function Tooltip_ReadCube() {
    ShowTooltip('<div id="box-modal-drop-shadow-hover"><div id="box-abstract-hover"><p><b>Enhanced PDF</b></p><p>Clicking “Enhanced PDF” will open content in ReadCube&#0153;, a free, browser-based workflow tool for organizing, reading, citing and annotating PDF articles. You will automatically view the Enhanced PDF directly in your browser - there is no need to do anything, nor do you need to create a free ReadCube Account to access the Enhanced PDF files available on this site.</p><p><b>NOTE: Standard article PDFs can be downloaded from the Readcube Web Reader.</b> Registering for a free ReadCube account allows you to download the enhanced PDF version of articles directly to your ReadCube Desktop or Mobile library, compatible with both Mac and PC.</p></div></div><div id="ej-clear-float"></div>');
}

//Function to show tool-tip message incase of "I am a Society Member" on ArtcleViewerPage
function Tooltip_IAmASocietyMember() {
    ShowTooltip('<div id="box-modal-drop-shadow-hover"><div id="box-abstract-hover">Login, register, or activate your online subscription.<p><strong>Note</strong>: If your society membership provides for full-access to this article, you may need to login on your society\'s web site first.</p></div></div><div id="ej-clear-float"></div>');
}

//Function to show tool-tip message incase of "I am a Subscriber" on ArtcleViewerPage
function Tooltip_IAmASubscriber() {
    ShowTooltip('<div id="box-modal-drop-shadow-hover"><div id="box-abstract-hover">Login, register, or activate your online subscription.</div></div><div id="ej-clear-float"></div>');
}

//function to show the too-tip message of Group Practice Marketing
function ToolTip_GroupPracticeMarketing(message) {
    ShowTooltip('<div id="box-modal-drop-shadow-hover"><div id="box-text-hover-03"><p><span class="ej-tooltip-head-sub-options">Are you part of a Group Practice?</span><br /> ' + message + '</p></div></div><div id="ej-clear-float"></div>');
}

//function to show the too-tip message of Individual registration
function ToolTip_IndividualSubscriberMarketing(message) {
    ShowTooltip('<div id="box-modal-drop-shadow-hover"><div id="box-text-hover-03"><p><span class="ej-tooltip-head-sub-options">Individual Subscriptions</span><br>' + message + '</p></div></div>');
}

//function to show the too-tip message of Complete search term in Most Frequent Searches Facet
function ToolTip_searchTerm(searchTerm) {
    if (searchTerm.length > 80) {
        ShowTooltip('<div id="box-modal-drop-shadow-hover"><div id="box-text-hover"><p>' +
            searchTerm +
            '</p></div></div>');
    }
}





function ProcessImn() {};
function ProcessImnMarkers() {};

function InstitutionWrapperControl_ImageMouseOut() {
    UnTip();
}

function InstitutionWrapperControl_ShowRollOverInstitutionsDetails(htmlText, rolloverDisplayMilliseconds) {
    Tip(htmlText, BORDERWIDTH, 0, SHADOW, false, BGCOLOR, '', WIDTH, 0, DELAY, rolloverDisplayMilliseconds);
}

function showExportToCitationPopUpOnclick() {
    $find(showExportToCitationPopUp()).show();
}

function ArticleTools_ShowAddToMyCollectionsPopUp() {
    addToMyCollectionsLinkClicked('');
    showAddToMyCollectionPopUp();
}

function showRightsLinkPopUp(url, publisherName, publication, title, publicationDate, author, volumeNum, issueNum, copyright, contentID, URL_Coll_ID, isArticleFreeOrOpenAccess) {
    var location = url
                + "?publisherName=" + encodeURI(publisherName)
                + "&publication=" + encodeURI(publication)
                + "&title=" + encodeURI(title)
                + "&publicationDate=" + encodeURI(publicationDate)
                + "&author=" + encodeURI(author)
                + "&volumeNum=" + encodeURI(volumeNum)
                + "&issueNum=" + encodeURI(issueNum)
                + "&copyright=" + encodeURI(copyright)
                + "&contentID=" + encodeURI(contentID);
               
        if(URL_Coll_ID != '')
        {
            location = location + URL_Coll_ID;
		}
        location = location + "&orderBeanReset=" + encodeURI('True');

        if(!isArticleFreeOrOpenAccess)
        {
            location = location + '&contentoffers=yes';
		}
		
    window.open(location, 'Rightslink', 'location=no,toolbar=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=650,height=550');
}

function showPatientorCaregiverlinkPopUp(url, publisherName, publication, title, publicationDate, author, volumeNum, issueNum, copyright, contentID, URL_Coll_ID,  isArticleFreeOrOpenAccess) {
    var location = url
                + "?publisherName=" + encodeURI(publisherName)
                + "&publication=" + encodeURI(publication)
                + "&title=" + encodeURI(title)
                + "&publicationDate=" + encodeURI(publicationDate)
                + "&author=" + encodeURI(author)
                + "&volumeNum=" + encodeURI(volumeNum)
                + "&issueNum=" + encodeURI(issueNum)
                + "&copyright=" + encodeURI(copyright)
                + "&contentID=" + encodeURI(contentID);
    if (URL_Coll_ID != '') {
        location = location + URL_Coll_ID;
    }
    location = location + "&orderBeanReset=" + encodeURI('True');

    if (!isArticleFreeOrOpenAccess) {
        location = location + '&contentoffers=yes';
    }

    window.open(location, 'Rightslink', 'location=no,toolbar=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=650,height=550');
}

function restoreKeywords() {

    var keywords = getArticleKeywords();
    getKeywordTextID().value = keywords;
    getbtnSearchId().disabled = false;
}

function enableDisableButton() {

    var keywordTextArea = getKeywordTextID();

    if (keywordTextArea.value == null || keywordTextArea.value.trim() == "") {
        getbtnSearchId().disabled = true;
    }
    else {
        getbtnSearchId().disabled = false;
    }
}

function setTextSize(size) {
    getElementReferences();
    textDiv.style.fontSize = size;

    var smallText = document.getElementById('smallText');
    var medText = document.getElementById('medText');
    var largeText = document.getElementById('largeText');

    switch (size) {
        case 'Small':
            smallText.style.textDecoration = 'none';
            smallText.style.fontWeight = 'bold';
            medText.style.textDecoration = 'underline';
            medText.style.fontWeight = 'normal';
            largeText.style.textDecoration = 'underline';
            largeText.style.fontWeight = 'normal';
            break;
        case 'Medium':
            smallText.style.textDecoration = 'underline';
            smallText.style.fontWeight = 'normal';
            medText.style.textDecoration = 'none';
            medText.style.fontWeight = 'bold';
            largeText.style.textDecoration = 'underline';
            largeText.style.fontWeight = 'normal';
            break;
        case 'Large':
            smallText.style.textDecoration = 'underline';
            smallText.style.fontWeight = 'normal';
            medText.style.textDecoration = 'underline';
            medText.style.fontWeight = 'normal';
            largeText.style.textDecoration = 'none';
            largeText.style.fontWeight = 'bold';
            break;
    }
}

function validatePhone() {

    if (typeof getPhone1Field == 'function' && getPhone1Field != undefined) {
        var txtPhone1 = getPhone1Field();
    }

    if (typeof getPhone2Field == 'function' && getPhone2Field != undefined) {
        var txtPhone2 = getPhone2Field();
    }

    if (typeof getPhone3Field == 'function' && getPhone3Field != undefined) {
        var txtPhone3 = getPhone3Field();
    }

    if (typeof getPhoneType1Field == 'function' && getPhoneType1Field != undefined) {
        var cmbPhoneType1 = getPhoneType1Field();
    }

    if (typeof getPhoneType2Field == 'function' && getPhoneType2Field != undefined) {
        var cmbPhoneType2 = getPhoneType2Field();
    }

    if (typeof getPhoneType3Field == 'function' && getPhoneType3Field != undefined) {
        var cmbPhoneType3 = getPhoneType3Field();
    }
    if (txtPhone1 != null) {
        if (txtPhone1.value != '' && cmbPhoneType1.selectedIndex == 0) {
            alert('Please select phone type for Phone 1');
            cmbPhoneType1.focus();
            return false;
        }
    }
    if (txtPhone2 != null) {
        if (txtPhone2.value != '' && cmbPhoneType2.selectedIndex == 0) {
            alert('Please select phone type for Phone 2');
            cmbPhoneType2.focus();
            return false;
        }
    }
    if (txtPhone3 != null) {
        if (txtPhone3.value != '' && cmbPhoneType3.selectedIndex == 0) {
            alert('Please select phone type for Phone 3');
            cmbPhoneType3.focus();
            return false;
        }
    }
    return true;
}

// This function checks whether there is text inside search textbox or not. 
function controlEnterSearchTopBox(obj,searchTextbox,event){
	if(obj!=null){
	   var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
	   if(keyCode==13){
	     var searchText = document.getElementById(searchTextbox).value;
		 var trimmedText=trimDefaultAdvancedText(searchText);
		 if(trimmedText.length != 0){                      // If length of the text inside the search textbox is 
			var enterbutton = document.getElementById(obj) // not zero then it will call click event of the search button.
			if(enterbutton != null){
			enterbutton.click();
			}
			return false;
		 }
		 else{
		 return false;
		 } 
	   }
	   else{
	   return true;
	   }
	}
}

function controlEnter(obj, event) {
    if (obj != null) {
        var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
        if (keyCode == 13) {
            var enterButton = document.getElementById(obj)
            if (enterButton != null) {
                enterButton.click();
            }
            return false;
        }
        else {
            return true;
        }
    }
}

//Start My Collections Navigator JS
function afterHeaderClick(gridName, ColID, Btn) {
    rowIndex = ColID.split("_");
    col = rowIndex[2];
    if ((rowIndex[2] == 0) && rowIndex[1] == "c") {
        var col = igtbl_getElementById(ColID);
        if (col.innerText != "") {
            col.style.fontWeight = "bold";
            col.style.textDecoration = "none";
            var index = col.innerHTML.indexOf(';');
            if (index == -1) {
                index = col.innerHTML.indexOf('<');
                col.innerHTML = col.innerHTML.substring(0, index) + "&nbsp;" + col.innerHTML.substring(index);
            }

        }
    }
}

function beforeHeaderClick(gridName, ColID, Btn) {
    rowIndex = ColID.split("_");
    col = rowIndex[2];
    if ((rowIndex[2] == 0) && rowIndex[1] == "c") {
        var col = igtbl_getElementById(ColID);
        col.parentNode.childNodes[0].style.fontWeight = "normal";
        col.parentNode.childNodes[2].style.fontWeight = "normal";
        col.parentNode.childNodes[0].innerText = "Name";
        col.parentNode.childNodes[0].innerHTML = "Name";
        col.parentNode.childNodes[2].innerText = "Modified";
        col.parentNode.childNodes[2].innerHTML = "Modified";
        col.parentNode.childNodes[0].style.textDecoration = "underline";
        col.parentNode.childNodes[2].style.textDecoration = "underline";
    }
}

function onLoadStyle(gridName) {
    //get the grid object from grid id
    var grid = igtbl_getGridById(gridName);
    grid.Element.childNodes[1].childNodes[0].childNodes[0].style.fontWeight = "bold";
    grid.Element.childNodes[1].childNodes[0].childNodes[1].style.cursor = "default";
    grid.Element.childNodes[1].childNodes[0].childNodes[2].style.textDecoration = "underline";
    grid.Element.childNodes[1].childNodes[0].childNodes[0].innerText = "Name <img src='/_layouts/1033/images/OAKS.Journals/icon-sort.gif'></img>";
    grid.Element.childNodes[1].childNodes[0].childNodes[0].innerHTML = "Name <img src='/_layouts/1033/images/OAKS.Journals/icon-sort.gif'></img>";
}
//End of My Collections Navigator JS

//Start Saved Search Grid JS 
function afterHeaderofGridClick(gridName, ColID, Btn) {
    rowIndex = ColID.split("_");
    col = rowIndex[2];
    if ((rowIndex[2] == 0) && rowIndex[1] == "c") {
        var col = igtbl_getElementById(ColID);
        if (col.innerText != "") {
            col.style.fontWeight = "bold";
            col.style.textDecoration = "none";
            var index = col.innerHTML.indexOf(';');
            if (index == -1) {
                index = col.innerHTML.indexOf('<');
                col.innerHTML = col.innerHTML.substring(0, index) + "&nbsp;" + col.innerHTML.substring(index);
            }
        }
    }
}

function beforeHeaderofGridClick(gridName, ColID, Btn) {
    rowIndex = ColID.split("_");
    col = rowIndex[2];
    if ((rowIndex[2] == 0) && rowIndex[1] == "c") {
        var col = igtbl_getElementById(ColID);
        col.parentNode.childNodes[0].style.fontWeight = "normal";
        col.parentNode.childNodes[1].style.fontWeight = "normal";
        col.parentNode.childNodes[0].innerText = "Search Name";
        col.parentNode.childNodes[0].innerHTML = "Search Name";
        col.parentNode.childNodes[1].innerText = "Saved";
        col.parentNode.childNodes[1].innerHTML = "Saved";
        col.parentNode.childNodes[0].style.textDecoration = "underline";
        col.parentNode.childNodes[1].style.textDecoration = "underline";
    }
}

function onLoadofGridStyle(gridName) {
    //get the grid object from grid id
    var grid = igtbl_getGridById(gridName);
    grid.Element.childNodes[1].childNodes[0].childNodes[0].style.fontWeight = "bold";
    grid.Element.childNodes[1].childNodes[0].childNodes[1].style.textDecoration = "underline";
    grid.Element.childNodes[1].childNodes[0].childNodes[2].style.cursor = "default";
    grid.Element.childNodes[1].childNodes[0].childNodes[0].innerText = "Search Name <img src='/_layouts/1033/images/OAKS.Journals/icon-sort.gif'></img>";
    grid.Element.childNodes[1].childNodes[0].childNodes[0].innerHTML = "Search Name <img src='/_layouts/1033/images/OAKS.Journals/icon-sort.gif'></img>";
}
//End of Saved Search Grid JS

//Start Session Timeout Pop up JS
function closeTimeoutPopup() { getTimeoutPopup().hide(); }
//End of Session Timeout Pop up JS

//Start Feedback JS

//Clears the textbox on focus if textbox have default text.
function clearFeedbackText(obj) {
    if (obj != null) {
        if (obj.value == 'Enter your email address' || obj.value == 'Enter your full name' || obj.value == 'Enter your comments') {
            obj.value = '';
        }
    }
}

//On blur, if textbox is empty, default text is added.
function defaultFeedbackText(obj) {
    if (obj != null && getTxtEmailAddress() != null && getTxtFullName() != null && getTxtComments() != null) {
        if (obj.value == "") {
            if (obj == getTxtEmailAddress()) {
                obj.value = 'Enter your email address';
            }
            if (obj == getTxtFullName()) {
                obj.value = 'Enter your full name';
            }
            if (obj == getTxtComments()) {
                obj.value = 'Enter your comments';
            }
        }
    }
}

//Onkeypress,determines the count that is left that can be accepted by the textbox.
function countLeft(field, max) {
    if (field != null && getHfldRemainingCharacterCount() != null && getLbldRemainingCharacterCount() != null) {
        if (field.value.length > max) {
            field.value = field.value.substring(0, max);
        }
        else {
            getHfldRemainingCharacterCount().value = max - field.value.length;
            getLbldRemainingCharacterCount().innerHTML = getHfldRemainingCharacterCount().value;
        }
    }
}

//Onkeyup,determines whether the maximum length of textbox is reached.
function textBoxMaxLength() {
    if (getTxtComments() != null) {
        if (getTxtComments().value.length >= 500) {
            return false;
        }
        return true;
    }
}

//End Feedback JS

//For EULA on Membership

function onEULAChkAcknowledge_Click() {

    var btnVariable = getCompleteRegistrationButton();

    if (btnVariable != null) {

        if (btnVariable.disabled == true) {
            btnVariable.disabled = false;
        }
        else {
            btnVariable.disabled = true;
        }
    }

}
//For Privacy Policy check
function Check_EULA_PrivacyPolicy_Click() {
    var btnVariable = getCompleteRegistrationButton();
    var chkAcknowledge = getAcknowledgeField();
    var chkPrivacyPolicy = getPrivacyPolicyField();

    if (chkAcknowledge.checked && chkPrivacyPolicy.checked) {
        btnVariable.disabled = false
    }
    else {
        btnVariable.disabled = true
    }
}


function ReverseContentDisplay(d) {
    if (d.length < 1) { return; }
    if (document.getElementById(d).style.display == "none") { document.getElementById(d).style.display = "block"; }
    else { document.getElementById(d).style.display = "none"; }
}

function closeSessionExpiredMesaage() {

    var sessionTimeOutDiv = $(".ej-session-expired-from-login");

    sessionTimeOutDiv.hide();
}

function closeRenewSubscriptionMesaage() {

    var renewSubscriptiontDiv = $(".ej-renew-subscription");

    renewSubscriptiontDiv.hide();

    var CookieValue = getCookie("subscriptionalertenabled");

    if (CookieValue == "yes") {
        setCookie("subscriptionalertenabled", "no", 24);
    }
}

function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') c = c.substring(1);
        if (c.indexOf(name) != -1) return c.substring(name.length, c.length);
    }
    return "";
}

function setCookie(cname, cvalue, hours) {
    var d = new Date();
    d.setTime(d.getTime() + (hours * 60 * 60 * 1000));
    var expires = "expires=" + d.toGMTString();
    var path = "path=/";
    document.cookie = cname + "=" + cvalue + "; " + expires + "; " + path;
}




function closeSSOConformationMesaage() {

    var confirmationDiv = $(".ej-inline-confirmation");

    confirmationDiv.hide();
}

function closePAPNotFoundMesaage() {

    var confirmationDiv = $(".ej-invalid-pap");

    confirmationDiv.hide();
}

function truncateTitle(container, control) {

    var a_tag = $(control);
    var spanh = $(container);
   
    for (var i = 0; i < a_tag.length; i++) {
        //If container heigth is more than the content then apply ellipsis
        var count = 0;
		var numberOfSpaces = $(a_tag[i]).text().split(/\s/).length - 1;
        while ($(a_tag[i]).outerHeight() > $(spanh[i]).height()) {
				count++;
                $(a_tag[i]).text(function (index, text) {
                    return text.replace(/\W*\s(\S)*$/, '...');
                });
                if (count > numberOfSpaces - 5) break; 
        }      
    }
}

function truncateTitleAndDesciprtion(container, control, containerDesc, controlDesc) {

    var a_tag = $(control);
    var spanh = $(container);

    var a_desc = $(controlDesc);
    var spanDesc = $(containerDesc);

    for (var i = 0; i < a_tag.length; i++) {
        //If container heigth is more than the content then apply ellipsis
        while ($(a_tag[i]).outerHeight() > $(spanh[i]).height()) {
            $(a_tag[i]).text(function (index, text) {
                return text.replace(/\W*\s(\S)*$/, '...');
            });
        }

        while ($(a_desc[i]).outerHeight() > $(spanDesc[i]).height()) {
            $(a_desc[i]).text(function (index, text) {
                return text.replace(/\W*\s(\S)*$/, '...');
            });
        }
    }
}


//Clears the txtKeywords textbox on focus if txtKeywords have default text and enables Search button
function clearAdvancedText(obj) {
    if (obj != null && getAdvancedButton() != null && getAdvancedSearch() != null && getHfldAdvanceKeywords() != null && getTxtVolume() != null && getTxtIssue().value != null && getTxtPageNumber().value != null) {
        if ((getAdvancedSearch().value == "Enter Keywords" && getHfldAdvanceKeywords().value == 'disableButton') || (getTxtVolume().value == '' || getTxtIssue().value == '' || getTxtPageNumber().value == '')) {
            //Explicitly check if the onfocus() method is called on txtKeywords textbox
            if (obj == getAdvancedSearch() && (getAdvancedSearch().value == "Enter Keywords" || getAdvancedSearch().value == "Search All Journals") && getHfldAdvanceKeywords().value == 'disableButton') {
                getAdvancedSearch().value = '';
                getHfldAdvanceKeywords().value = 'enableButton';
            }
            getAdvancedButton().disabled = false;
        }
    }
}
//On blur, if txtKeywords textbox is empty, default text is added and Search button is disabled
function defaultAdvancedText(obj) {
    if (obj != null && getAdvancedButton() != null && getAdvancedSearch() != null && getHfldAdvanceKeywords() != null && getTxtVolume() != null && getTxtIssue().value != null && getTxtPageNumber().value != null) {
        if ((trimDefaultAdvancedText(getAdvancedSearch().value) != "" && getHfldAdvanceKeywords().value == 'enableButton') || trimDefaultAdvancedText(getTxtVolume().value) != '' || trimDefaultAdvancedText(getTxtIssue().value) != '' || trimDefaultAdvancedText(getTxtPageNumber().value) != '') {
            getAdvancedButton().disabled = false;
        }
        else {
            getAdvancedButton().disabled = true;
            getTxtVolume().value = '';
            getTxtIssue().value = '';
            getTxtPageNumber().value = '';
        }
        //Explicitly check if the onblur() method is called on txtKeywords textbox to set default text
        if (obj == getAdvancedSearch() && trimDefaultAdvancedText(getAdvancedSearch().value) == "" && getHfldAdvanceKeywords().value == 'enableButton') {
            if (getContextJournalType() == "") {
                getAdvancedSearch().value = 'Search All Journals';
            }
            else {
                getAdvancedSearch().value = "Enter Keywords";
            }
            getHfldAdvanceKeywords().value = 'disableButton';
        }
    }
}

function citationTextChange() {

    if (typeof getTxtIssue == 'function' && typeof getTxtVolume == 'function' && typeof getTxtPageNumber == 'function') {

        if (getTxtIssue() != null && getTxtVolume() != null && getTxtPageNumber() != null) {
            
            getTxtIssue().disabled = trimDefaultAdvancedText(getTxtVolume().value) == '';
            if (getTxtIssue().disabled) {
                getTxtIssue().style.backgroundColor = "#CCC";
                getTxtIssue().value = '';
            }
            else {
                getTxtIssue().style.backgroundColor = "#FFF";
            }
            getTxtPageNumber().disabled = trimDefaultAdvancedText(getTxtIssue().value) == '';
            if (getTxtPageNumber().disabled) {
                getTxtPageNumber().style.backgroundColor = "#CCC";
                getTxtPageNumber().value = '';
            }
            else {
                getTxtPageNumber().style.backgroundColor = "#FFF";
            }
        }
    }
}

function trimDefaultAdvancedText(val) {
    var trimmedText = val.replace(/^\s+/, '');
    trimmedText = trimmedText.replace(/\s+$/, '');

    return trimmedText;
}

//Clears the txtKeywords textbox on focus if txtKeywords have default text and enables Search button
function clearNewSearchText(obj) {
    if (obj != null && getNewSearchHfldKeywords() != null && getNewSearchButton() != null) {
        if ((obj.value == 'Enter Keywords' || obj.value == 'Search All Journals') && getNewSearchHfldKeywords().value == 'disableButton') {
            obj.value = '';
            getNewSearchHfldKeywords().value = 'enableButton';
        }
        getNewSearchButton().disabled = false;
    }
}

//On blur, if txtKeywords textbox is empty, default text is added and Search button is disabled
function defaultNewSearchText(obj) {
    if (obj != null && getNewSearchHfldKeywords() != null && getNewSearchButton() != null) {
        if (trimDefaultNewSearchText(obj.value) == "") {
            if (getContextJournalType() == "") {
                obj.value = 'Search All Journals';
            }
            else {
                obj.value = 'Enter Keywords';
            }
            getNewSearchButton().disabled = true;
            getNewSearchHfldKeywords().value = 'disableButton';
        }
    }
}

function trimDefaultNewSearchText(val) {
    var trimmedText = val.replace(/^\s+/, '');
    trimmedText = trimmedText.replace(/\s+$/, '');

    return trimmedText;
}

function search_pageLoad(sender, args) {

    if (typeof getHfldKeywords == 'function' && getHfldKeywords != undefined) {
        if (getHfldKeywords().value == 'enableButton') {
            if (typeof getButton == 'function' && getButton != undefined) {
                getButton().disabled = false;
            }
        }
    }

    if (typeof getHfldAdvanceKeywords == 'function' && getHfldAdvanceKeywords != undefined) {
        if (getAdvancedButton() != null && getTxtVolume() != null && getTxtIssue().value != null && getTxtPageNumber().value != null) {
            if (getHfldAdvanceKeywords().value == 'enableButton' || getTxtVolume().value != '' || getTxtIssue().value != '' || getTxtPageNumber().value != '') {
                getAdvancedButton().disabled = false;
            }
        }
    }
}

//Clears the txtKeywords textbox on focus if txtKeywords have default text and enables Search button
function clearText(obj) {
    if (obj != null && getHfldKeywords() != null && getButton() != null) {
        if ((obj.value == 'Enter Keywords' || obj.value == 'Search All Journals') && getHfldKeywords().value == 'disableButton') {
            obj.value = '';
            getHfldKeywords().value = 'enableButton';
        }
        getButton().disabled = false;
    }
}

//On blur, if txtKeywords textbox is empty, default text is added and Search button is disabled
function defaultText(obj) {
    if (obj != null && getHfldKeywords() != null && getButton() != null) {
        if (trimDefaultText(obj.value) == "") {
            if (getContextJournalType() == "") {
                obj.value = 'Search All Journals';
            }
            else {
                obj.value = 'Enter Keywords';
            }
            getButton().disabled = true;
            getHfldKeywords().value = 'disableButton';
        }
    }
}

function trimDefaultText(val) {
    var trimmedText = val.replace(/^\s+/, '');
    trimmedText = trimmedText.replace(/\s+$/, '');

    return trimmedText;
}

var searchesDiv;
var parentDiv;
var hrefRecent;

function toggleSearchesDiv(id, parentDivId, thisId) {
    hrefRecent = thisId;
    searchesDiv = document.getElementById(id);

    if (searchesDiv.style.display == 'none') {
        searchesDiv.style.display = 'block';
        document.body.onmouseover = hideSearchesDiv;
        hrefRecent.className = 'ej-search-options-recent';
        parentDiv = document.getElementById(parentDivId)
        parentDiv.style.zIndex = 1;
    }
    else {
        hideSearchesDiv();
    }
}
function hideSearchesDiv() {
    if (searchesDiv != null) {
        searchesDiv.style.display = 'none';
    }
    if (parentDiv != null) {
        parentDiv.style.zIndex = 0;
    }
    if (hrefRecent != null) {
        hrefRecent.className = '';
    }

    document.body.onmouseover = null;    // Remove event handler when it's no longer needed
}
Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(ejournals_pageLoad);
Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(search_pageLoad);
Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(citationTextChange);

/* This notice must be untouched at all times.
Copyright (c) 2002-2008 Walter Zorn. All rights reserved.

wz_tooltip.js	 v. 5.20

The latest version is available at
http://www.walterzorn.com
or http://www.devira.com
or http://www.walterzorn.de

Created 1.12.2002 by Walter Zorn (Web: http://www.walterzorn.com )
Last modified: 1.8.2008

Easy-to-use cross-browser tooltips.
Just include the script at the beginning of the <body> section, and invoke
Tip('Tooltip text') to show and UnTip() to hide the tooltip, from the desired
HTML eventhandlers. Example:
<a onmouseover="Tip('Some text')" onmouseout="UnTip()" href="index.htm">My home page</a>
No container DIV required.
By default, width and height of tooltips are automatically adapted to content.
Is even capable of dynamically converting arbitrary HTML elements to tooltips
by calling TagToTip('ID_of_HTML_element_to_be_converted') instead of Tip(),
which means you can put important, search-engine-relevant stuff into tooltips.
Appearance & behaviour of tooltips can be individually configured
via commands passed to Tip() or TagToTip().

Tab Width: 4
LICENSE: LGPL

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License (LGPL) as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

For more details on the GNU Lesser General Public License,
see http://www.gnu.org/copyleft/lesser.html
*/

var config = new Object();


//===================  GLOBAL TOOPTIP CONFIGURATION  =========================//
var tt_Debug	= true		// false or true - recommended: false once you release your page to the public
var tt_Enabled	= true		// Allows to (temporarily) suppress tooltips, e.g. by providing the user with a button that sets this global variable to false
var TagsToTip	= false		// false or true - if true, HTML elements to be converted to tooltips via TagToTip() are automatically hidden;
							// if false, you should hide those HTML elements yourself

// For each of the following config variables there exists a command, which is
// just the variablename in uppercase, to be passed to Tip() or TagToTip() to
// configure tooltips individually. Individual commands override global
// configuration. Order of commands is arbitrary.
// Example: onmouseover="Tip('Tooltip text', LEFT, true, BGCOLOR, '#FF9900', FADEIN, 400)"

config. Above			= false 	// false or true - tooltip above mousepointer
config. BgColor 		= '#E2E7FF' // Background colour (HTML colour value, in quotes)
config. BgImg			= ''		// Path to background image, none if empty string ''
config. BorderColor		= '#003099'
config. BorderStyle		= 'solid'	// Any permitted CSS value, but I recommend 'solid', 'dotted' or 'dashed'
config. BorderWidth		= 1
config. CenterMouse		= false 	// false or true - center the tip horizontally below (or above) the mousepointer
config. ClickClose		= false 	// false or true - close tooltip if the user clicks somewhere
config. ClickSticky		= false		// false or true - make tooltip sticky if user left-clicks on the hovered element while the tooltip is active
config. CloseBtn		= false 	// false or true - closebutton in titlebar
config. CloseBtnColors	= ['#990000', '#FFFFFF', '#DD3333', '#FFFFFF']	  // [Background, text, hovered background, hovered text] - use empty strings '' to inherit title colours
config. CloseBtnText	= '&nbsp;X&nbsp;'	// Close button text (may also be an image tag)
config. CopyContent		= true		// When converting a HTML element to a tooltip, copy only the element's content, rather than converting the element by its own
config. Delay			= 400		// Time span in ms until tooltip shows up
config. Duration		= 0 		// Time span in ms after which the tooltip disappears; 0 for infinite duration, < 0 for delay in ms _after_ the onmouseout until the tooltip disappears
config. FadeIn			= 0 		// Fade-in duration in ms, e.g. 400; 0 for no animation
config. FadeOut			= 0
config. FadeInterval	= 30		// Duration of each fade step in ms (recommended: 30) - shorter is smoother but causes more CPU-load
config. Fix				= null		// Fixated position, two modes. Mode 1: x- an y-coordinates in brackets, e.g. [210, 480]. Mode 2: Show tooltip at a position related to an HTML element: [ID of HTML element, x-offset, y-offset from HTML element], e.g. ['SomeID', 10, 30]. Value null (default) for no fixated positioning.
config. FollowMouse		= true		// false or true - tooltip follows the mouse
config. FontColor		= '#000044'
config. FontFace		= 'Verdana,Geneva,sans-serif'
config. FontSize		= '8pt' 	// E.g. '9pt' or '12px' - unit is mandatory
config. FontWeight		= 'normal'	// 'normal' or 'bold';
config. Height			= 0 		// Tooltip height; 0 for automatic adaption to tooltip content, < 0 (e.g. -100) for a maximum for automatic adaption
config. JumpHorz		= false		// false or true - jump horizontally to other side of mouse if tooltip would extend past clientarea boundary
config. JumpVert		= true		// false or true - jump vertically		"
config. Left			= false 	// false or true - tooltip on the left of the mouse
config. OffsetX			= 14		// Horizontal offset of left-top corner from mousepointer
config. OffsetY			= 8 		// Vertical offset
config. Opacity			= 100		// Integer between 0 and 100 - opacity of tooltip in percent
config. Padding			= 3 		// Spacing between border and content
config. Shadow			= false 	// false or true
config. ShadowColor		= '#C0C0C0'
config. ShadowWidth		= 5
config. Sticky			= false 	// false or true - fixate tip, ie. don't follow the mouse and don't hide on mouseout
config. TextAlign		= 'left'	// 'left', 'right' or 'justify'
config. Title			= ''		// Default title text applied to all tips (no default title: empty string '')
config. TitleAlign		= 'left'	// 'left' or 'right' - text alignment inside the title bar
config. TitleBgColor	= ''		// If empty string '', BorderColor will be used
config. TitleFontColor	= '#FFFFFF'	// Color of title text - if '', BgColor (of tooltip body) will be used
config. TitleFontFace	= ''		// If '' use FontFace (boldified)
config. TitleFontSize	= ''		// If '' use FontSize
config. TitlePadding	= 2
config. Width			= 0 		// Tooltip width; 0 for automatic adaption to tooltip content; < -1 (e.g. -240) for a maximum width for that automatic adaption;
									// -1: tooltip width confined to the width required for the titlebar
//=======  END OF TOOLTIP CONFIG, DO NOT CHANGE ANYTHING BELOW  ==============//




//=====================  PUBLIC  =============================================//
//the only common place where we can check for the mobile device, all other calls are spread among the projects
function isMobileDevice() {
    if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
        return true;
    }
    return false;
}

function Tip()
{
    if (!isMobileDevice())
	    tt_Tip(arguments, null);
}
function TagToTip()
{
    if (!isMobileDevice()) {
        var t2t = tt_GetElt(arguments[0]);
        if (t2t)
            tt_Tip(arguments, t2t);
    }
}
function UnTip()
{
	tt_OpReHref();
	if(tt_aV[DURATION] < 0 && (tt_iState & 0x2))
		tt_tDurt.Timer("tt_HideInit()", -tt_aV[DURATION], true);
	else if(!(tt_aV[STICKY] && (tt_iState & 0x2)))
		tt_HideInit();
}

//==================  PUBLIC PLUGIN API	 =====================================//
// Extension eventhandlers currently supported:
// OnLoadConfig, OnCreateContentString, OnSubDivsCreated, OnShow, OnMoveBefore,
// OnMoveAfter, OnHideInit, OnHide, OnKill

var tt_aElt = new Array(10), // Container DIV, outer title & body DIVs, inner title & body TDs, closebutton SPAN, shadow DIVs, and IFRAME to cover windowed elements in IE
tt_aV = new Array(),	// Caches and enumerates config data for currently active tooltip
tt_sContent,			// Inner tooltip text or HTML
tt_t2t, tt_t2tDad,		// Tag converted to tip, and its DOM parent element
tt_scrlX = 0, tt_scrlY = 0,
tt_musX, tt_musY,
tt_over,
tt_x, tt_y, tt_w, tt_h; // Position, width and height of currently displayed tooltip

function tt_Extension()
{
	tt_ExtCmdEnum();
	tt_aExt[tt_aExt.length] = this;
	return this;
}
function tt_SetTipPos(x, y)
{
	var css = tt_aElt[0].style;

	tt_x = x;
	tt_y = y;
	css.left = x + "px";
	css.top = y + "px";
	if(tt_ie56)
	{
		var ifrm = tt_aElt[tt_aElt.length - 1];
		if(ifrm)
		{
			ifrm.style.left = css.left;
			ifrm.style.top = css.top;
		}
	}
}
function tt_HideInit()
{
	if(tt_iState)
	{
		tt_ExtCallFncs(0, "HideInit");
		tt_iState &= ~0x4;
		if(tt_flagOpa && tt_aV[FADEOUT])
		{
			tt_tFade.EndTimer();
			if(tt_opa)
			{
				var n = Math.round(tt_aV[FADEOUT] / (tt_aV[FADEINTERVAL] * (tt_aV[OPACITY] / tt_opa)));
				tt_Fade(tt_opa, tt_opa, 0, n);
				return;
			}
		}
		tt_tHide.Timer("tt_Hide();", 1, false);
	}
}
function tt_Hide()
{
	if(tt_db && tt_iState)
	{
		tt_OpReHref();
		if(tt_iState & 0x2)
		{
			tt_aElt[0].style.visibility = "hidden";
			tt_ExtCallFncs(0, "Hide");
		}
		tt_tShow.EndTimer();
		tt_tHide.EndTimer();
		tt_tDurt.EndTimer();
		tt_tFade.EndTimer();
		if(!tt_op && !tt_ie)
		{
			tt_tWaitMov.EndTimer();
			tt_bWait = false;
		}
		if(tt_aV[CLICKCLOSE] || tt_aV[CLICKSTICKY])
			tt_RemEvtFnc(document, "mouseup", tt_OnLClick);
		tt_ExtCallFncs(0, "Kill");
		// In case of a TagToTip tip, hide converted DOM node and
		// re-insert it into DOM
		if(tt_t2t && !tt_aV[COPYCONTENT])
			tt_UnEl2Tip();
		tt_iState = 0;
		tt_over = null;
		tt_ResetMainDiv();
		if(tt_aElt[tt_aElt.length - 1])
			tt_aElt[tt_aElt.length - 1].style.display = "none";
	}
}
function tt_GetElt(id)
{
	return(document.getElementById ? document.getElementById(id)
			: document.all ? document.all[id]
			: null);
}
function tt_GetDivW(el)
{
	return(el ? (el.offsetWidth || el.style.pixelWidth || 0) : 0);
}
function tt_GetDivH(el)
{
	return(el ? (el.offsetHeight || el.style.pixelHeight || 0) : 0);
}
function tt_GetScrollX()
{
	return(window.pageXOffset || (tt_db ? (tt_db.scrollLeft || 0) : 0));
}
function tt_GetScrollY()
{
	return(window.pageYOffset || (tt_db ? (tt_db.scrollTop || 0) : 0));
}
function tt_GetClientW()
{
	var de = document.documentElement;
	return((de && de.clientWidth) ? de.clientWidth : (document.body.clientWidth || window.innerWidth || 0));
}
function tt_GetClientH()
{
	var de = document.documentElement;
	return((de && de.clientHeight) ? de.clientHeight : (document.body.clientHeight || window.innerHeight || 0));
}
function tt_GetEvtX(e)
{
	return (e ? ((typeof(e.pageX) != tt_u) ? e.pageX : (e.clientX + tt_scrlX)) : 0);
}
function tt_GetEvtY(e)
{
	return (e ? ((typeof(e.pageY) != tt_u) ? e.pageY : (e.clientY + tt_scrlY)) : 0);
}
function tt_AddEvtFnc(el, sEvt, PFnc)
{
	if(el)
	{
		if(el.addEventListener)
			el.addEventListener(sEvt, PFnc, false);
		else
			el.attachEvent("on" + sEvt, PFnc);
	}
}
function tt_RemEvtFnc(el, sEvt, PFnc)
{
	if(el)
	{
		if(el.removeEventListener)
			el.removeEventListener(sEvt, PFnc, false);
		else
			el.detachEvent("on" + sEvt, PFnc);
	}
}
function tt_GetDad(el)
{
	return(el.parentNode || el.parentElement || el.offsetParent);
}
function tt_MovDomNode(el, dadFrom, dadTo)
{
	if(dadFrom)
		dadFrom.removeChild(el);
	if(dadTo)
		dadTo.appendChild(el);
}

//======================  PRIVATE  ===========================================//
var tt_aExt = new Array(),	// Array of extension objects

tt_db, tt_op, tt_ie, tt_ie56, tt_bBoxOld,	// Browser flags
tt_body,
tt_ovr_,				// HTML element the mouse is currently over
tt_flagOpa, 			// Opacity support: 1=IE, 2=Khtml, 3=KHTML, 4=Moz, 5=W3C
tt_maxPosX, tt_maxPosY,
tt_iState = 0,			// Tooltip active |= 1, shown |= 2, move with mouse |= 4
tt_opa, 				// Currently applied opacity
tt_bJmpVert, tt_bJmpHorz,// Tip temporarily on other side of mouse
tt_elDeHref,			// The tag from which we've removed the href attribute
// Timer
tt_tShow = new Number(0), tt_tHide = new Number(0), tt_tDurt = new Number(0),
tt_tFade = new Number(0), tt_tWaitMov = new Number(0),
tt_bWait = false,
tt_u = "undefined";


function tt_Init()
{
	tt_MkCmdEnum();
	// Send old browsers instantly to hell
	if(!tt_Browser() || !tt_MkMainDiv())
		return;
	// Levy 06/11/2008: Important! IE doesn't fire an onscroll when a page
	// refresh is made, so we need to recalc page positions on init.
	tt_OnScrl();
	tt_IsW3cBox();
	tt_OpaSupport();
	tt_AddEvtFnc(window, "scroll", tt_OnScrl);
	// IE doesn't fire onscroll event when switching to fullscreen;
	// fix suggested by Yoav Karpeles 14.2.2008
	tt_AddEvtFnc(window, "resize", tt_OnScrl);
	tt_AddEvtFnc(document, "mousemove", tt_Move);
	// In Debug mode we search for TagToTip() calls in order to notify
	// the user if they've forgotten to set the TagsToTip config flag
	if(TagsToTip || tt_Debug)
		tt_SetOnloadFnc();
	// Ensure the tip be hidden when the page unloads
	tt_AddEvtFnc(window, "unload", tt_Hide);
}
// Creates command names by translating config variable names to upper case
function tt_MkCmdEnum()
{
	var n = 0;
	for(var i in config)
		eval("window." + i.toString().toUpperCase() + " = " + n++);
	tt_aV.length = n;
}
function tt_Browser()
{
	var n, nv, n6, w3c;

	n = navigator.userAgent.toLowerCase(),
	nv = navigator.appVersion;
	tt_op = (document.defaultView && typeof(eval("w" + "indow" + "." + "o" + "p" + "er" + "a")) != tt_u);
	tt_ie = n.indexOf("msie") != -1 && document.all && !tt_op;
	if(tt_ie)
	{
		var ieOld = (!document.compatMode || document.compatMode == "BackCompat");
		tt_db = !ieOld ? document.documentElement : (document.body || null);
		if(tt_db)
			tt_ie56 = parseFloat(nv.substring(nv.indexOf("MSIE") + 5)) >= 5.5
					&& typeof document.body.style.maxHeight == tt_u;
	}
	else
	{
		tt_db = document.documentElement || document.body ||
				(document.getElementsByTagName ? document.getElementsByTagName("body")[0]
				: null);
		if(!tt_op)
		{
			n6 = document.defaultView && typeof document.defaultView.getComputedStyle != tt_u;
			w3c = !n6 && document.getElementById;
		}
	}
	tt_body = (document.getElementsByTagName ? document.getElementsByTagName("body")[0]
				: (document.body || null));
	if(tt_ie || n6 || tt_op || w3c)
	{
		if(tt_body && tt_db)
		{
			if(document.attachEvent || document.addEventListener)
				return true;
		}
		else
			tt_Err("wz_tooltip.js must be included INSIDE the body section,"
					+ " immediately after the opening <body> tag.", false);
	}
	tt_db = null;
	return false;
}
function tt_MkMainDiv()
{
	// Create the tooltip DIV
	if(tt_body.insertAdjacentHTML)
		tt_body.insertAdjacentHTML("afterBegin", tt_MkMainDivHtm());
	else if(typeof tt_body.innerHTML != tt_u && document.createElement && tt_body.appendChild)
		tt_body.appendChild(tt_MkMainDivDom());
	if(window.tt_GetMainDivRefs /* FireFox Alzheimer */ && tt_GetMainDivRefs())
		return true;
	tt_db = null;
	return false;
}
function tt_MkMainDivHtm()
{
	return('<div id="WzTtDiV"></div>' +
			(tt_ie56 ? ('<iframe id="WzTtIfRm" src="javascript:false" scrolling="no" frameborder="0" style="filter:Alpha(opacity=0);position:absolute;top:0px;left:0px;display:none;"></iframe>')
			: ''));
}
function tt_MkMainDivDom()
{
	var el = document.createElement("div");
	if(el)
		el.id = "WzTtDiV";
	return el;
}
function tt_GetMainDivRefs()
{
	tt_aElt[0] = tt_GetElt("WzTtDiV");
	if(tt_ie56 && tt_aElt[0])
	{
		tt_aElt[tt_aElt.length - 1] = tt_GetElt("WzTtIfRm");
		if(!tt_aElt[tt_aElt.length - 1])
			tt_aElt[0] = null;
	}
	if(tt_aElt[0])
	{
		var css = tt_aElt[0].style;

		css.visibility = "hidden";
		css.position = "absolute";
		css.overflow = "hidden";
		return true;
	}
	return false;
}
function tt_ResetMainDiv()
{
	tt_SetTipPos(0, 0);
	tt_aElt[0].innerHTML = "";
	tt_aElt[0].style.width = "auto";
	tt_h = 0;
}
function tt_IsW3cBox()
{
	var css = tt_aElt[0].style;

	css.padding = "10px";
	css.width = "40px";
	tt_bBoxOld = (tt_GetDivW(tt_aElt[0]) == 40);
	css.padding = "0px";
	tt_ResetMainDiv();
}
function tt_OpaSupport()
{
	var css = tt_body.style;

	tt_flagOpa = (typeof(css.KhtmlOpacity) != tt_u) ? 2
				: (typeof(css.KHTMLOpacity) != tt_u) ? 3
				: (typeof(css.MozOpacity) != tt_u) ? 4
				: (typeof(css.opacity) != tt_u) ? 5
				: (typeof(css.filter) != tt_u) ? 1
				: 0;
}
// Ported from http://dean.edwards.name/weblog/2006/06/again/
// (Dean Edwards et al.)
function tt_SetOnloadFnc()
{
	tt_AddEvtFnc(document, "DOMContentLoaded", tt_HideSrcTags);
	tt_AddEvtFnc(window, "load", tt_HideSrcTags);
	if(tt_body.attachEvent)
		tt_body.attachEvent("onreadystatechange",
			function() {
				if(tt_body.readyState == "complete")
					tt_HideSrcTags();
			} );
	if(/WebKit|KHTML/i.test(navigator.userAgent))
	{
		var t = setInterval(function() {
					if(/loaded|complete/.test(document.readyState))
					{
						clearInterval(t);
						tt_HideSrcTags();
					}
				}, 10);
	}
}
function tt_HideSrcTags()
{
	if(!window.tt_HideSrcTags || window.tt_HideSrcTags.done)
		return;
	window.tt_HideSrcTags.done = true;
	if(!tt_HideSrcTagsRecurs(tt_body))
		tt_Err("There are HTML elements to be converted to tooltips.\nIf you"
				+ " want these HTML elements to be automatically hidden, you"
				+ " must edit wz_tooltip.js, and set TagsToTip in the global"
				+ " tooltip configuration to true.", true);
}
function tt_HideSrcTagsRecurs(dad)
{
	var ovr, asT2t;
	// Walk the DOM tree for tags that have an onmouseover or onclick attribute
	// containing a TagToTip('...') call.
	// (.childNodes first since .children is bugous in Safari)
	var a = dad.childNodes || dad.children || null;

	for(var i = a ? a.length : 0; i;)
	{--i;
		if(!tt_HideSrcTagsRecurs(a[i]))
			return false;
		ovr = a[i].getAttribute ? (a[i].getAttribute("onmouseover") || a[i].getAttribute("onclick"))
				: (typeof a[i].onmouseover == "function") ? (a[i].onmouseover || a[i].onclick)
				: null;
		if(ovr)
		{
			asT2t = ovr.toString().match(/TagToTip\s*\(\s*'[^'.]+'\s*[\),]/);
			if(asT2t && asT2t.length)
			{
				if(!tt_HideSrcTag(asT2t[0]))
					return false;
			}
		}
	}
	return true;
}
function tt_HideSrcTag(sT2t)
{
	var id, el;

	// The ID passed to the found TagToTip() call identifies an HTML element
	// to be converted to a tooltip, so hide that element
	id = sT2t.replace(/.+'([^'.]+)'.+/, "$1");
	el = tt_GetElt(id);
	if(el)
	{
		if(tt_Debug && !TagsToTip)
			return false;
		else
			el.style.display = "none";
	}
	else
		tt_Err("Invalid ID\n'" + id + "'\npassed to TagToTip()."
				+ " There exists no HTML element with that ID.", true);
	return true;
}
function tt_Tip(arg, t2t)
{
	if(!tt_db)
		return;
	if(tt_iState)
		tt_Hide();
	if(!tt_Enabled)
		return;
	tt_t2t = t2t;
	if(!tt_ReadCmds(arg))
		return;
 	tt_iState = 0x1 | 0x4;
	tt_AdaptConfig1();
	tt_MkTipContent(arg);
	tt_MkTipSubDivs();
	tt_FormatTip();
	tt_bJmpVert = false;
	tt_bJmpHorz = false;
	tt_maxPosX = tt_GetClientW() + tt_scrlX - tt_w - 1;
	tt_maxPosY = tt_GetClientH() + tt_scrlY - tt_h - 1;
	tt_AdaptConfig2();
	// Ensure the tip be shown and positioned before the first onmousemove
	tt_OverInit();
	tt_ShowInit();
	tt_Move();
}
function tt_ReadCmds(a)
{
	var i;

	// First load the global config values, to initialize also values
	// for which no command is passed
	i = 0;
	for(var j in config)
		tt_aV[i++] = config[j];
	// Then replace each cached config value for which a command is
	// passed (ensure the # of command args plus value args be even)
	if(a.length & 1)
	{
		for(i = a.length - 1; i > 0; i -= 2)
			tt_aV[a[i - 1]] = a[i];
		return true;
	}
	tt_Err("Incorrect call of Tip() or TagToTip().\n"
			+ "Each command must be followed by a value.", true);
	return false;
}
function tt_AdaptConfig1()
{
	tt_ExtCallFncs(0, "LoadConfig");
	// Inherit unspecified title formattings from body
	if(!tt_aV[TITLEBGCOLOR].length)
		tt_aV[TITLEBGCOLOR] = tt_aV[BORDERCOLOR];
	if(!tt_aV[TITLEFONTCOLOR].length)
		tt_aV[TITLEFONTCOLOR] = tt_aV[BGCOLOR];
	if(!tt_aV[TITLEFONTFACE].length)
		tt_aV[TITLEFONTFACE] = tt_aV[FONTFACE];
	if(!tt_aV[TITLEFONTSIZE].length)
		tt_aV[TITLEFONTSIZE] = tt_aV[FONTSIZE];
	if(tt_aV[CLOSEBTN])
	{
		// Use title colours for non-specified closebutton colours
		if(!tt_aV[CLOSEBTNCOLORS])
			tt_aV[CLOSEBTNCOLORS] = new Array("", "", "", "");
		for(var i = 4; i;)
		{--i;
			if(!tt_aV[CLOSEBTNCOLORS][i].length)
				tt_aV[CLOSEBTNCOLORS][i] = (i & 1) ? tt_aV[TITLEFONTCOLOR] : tt_aV[TITLEBGCOLOR];
		}
		// Enforce titlebar be shown
		if(!tt_aV[TITLE].length)
			tt_aV[TITLE] = " ";
	}
	// Circumvents broken display of images and fade-in flicker in Geckos < 1.8
	if(tt_aV[OPACITY] == 100 && typeof tt_aElt[0].style.MozOpacity != tt_u && !Array.every)
		tt_aV[OPACITY] = 99;
	// Smartly shorten the delay for fade-in tooltips
	if(tt_aV[FADEIN] && tt_flagOpa && tt_aV[DELAY] > 100)
		tt_aV[DELAY] = Math.max(tt_aV[DELAY] - tt_aV[FADEIN], 100);
}
function tt_AdaptConfig2()
{
	if(tt_aV[CENTERMOUSE])
	{
		tt_aV[OFFSETX] -= ((tt_w - (tt_aV[SHADOW] ? tt_aV[SHADOWWIDTH] : 0)) >> 1);
		tt_aV[JUMPHORZ] = false;
	}
}
// Expose content globally so extensions can modify it
function tt_MkTipContent(a)
{
	if(tt_t2t)
	{
		if(tt_aV[COPYCONTENT])
			tt_sContent = tt_t2t.innerHTML;
		else
			tt_sContent = "";
	}
	else
		tt_sContent = a[0];
	tt_ExtCallFncs(0, "CreateContentString");
}
function tt_MkTipSubDivs()
{
	var sCss = 'position:relative;margin:0px;padding:0px;border-width:0px;left:0px;top:0px;line-height:normal;width:auto;',
	sTbTrTd = ' cellspacing="0" cellpadding="0" border="0" style="' + sCss + '"><tbody style="' + sCss + '"><tr><td ';

	tt_aElt[0].innerHTML =
		(''
		+ (tt_aV[TITLE].length ?
			('<div id="WzTiTl" style="position:relative;z-index:1;">'
			+ '<table id="WzTiTlTb"' + sTbTrTd + 'id="WzTiTlI" style="' + sCss + '">'
			+ tt_aV[TITLE]
			+ '</td>'
			+ (tt_aV[CLOSEBTN] ?
				('<td align="right" style="' + sCss
				+ 'text-align:right;">'
				+ '<span id="WzClOsE" style="position:relative;left:2px;padding-left:2px;padding-right:2px;'
				+ 'cursor:' + (tt_ie ? 'hand' : 'pointer')
				+ ';" onmouseover="tt_OnCloseBtnOver(1)" onmouseout="tt_OnCloseBtnOver(0)" onclick="tt_HideInit()">'
				+ tt_aV[CLOSEBTNTEXT]
				+ '</span></td>')
				: '')
			+ '</tr></tbody></table></div>')
			: '')
		+ '<div id="WzBoDy" style="position:relative;z-index:0;">'
		+ '<table' + sTbTrTd + 'id="WzBoDyI" style="' + sCss + '">'
		+ tt_sContent
		+ '</td></tr></tbody></table></div>'
		+ (tt_aV[SHADOW]
			? ('<div id="WzTtShDwR" style="position:absolute;overflow:hidden;"></div>'
				+ '<div id="WzTtShDwB" style="position:relative;overflow:hidden;"></div>')
			: '')
		);
	tt_GetSubDivRefs();
	// Convert DOM node to tip
	if(tt_t2t && !tt_aV[COPYCONTENT])
		tt_El2Tip();
	tt_ExtCallFncs(0, "SubDivsCreated");
}
function tt_GetSubDivRefs()
{
	var aId = new Array("WzTiTl", "WzTiTlTb", "WzTiTlI", "WzClOsE", "WzBoDy", "WzBoDyI", "WzTtShDwB", "WzTtShDwR");

	for(var i = aId.length; i; --i)
		tt_aElt[i] = tt_GetElt(aId[i - 1]);
}
function tt_FormatTip()
{
	var css, w, h, pad = tt_aV[PADDING], padT, wBrd = tt_aV[BORDERWIDTH],
	iOffY, iOffSh, iAdd = (pad + wBrd) << 1;

	//--------- Title DIV ----------
	if(tt_aV[TITLE].length)
	{
		padT = tt_aV[TITLEPADDING];
		css = tt_aElt[1].style;
		css.background = tt_aV[TITLEBGCOLOR];
		css.paddingTop = css.paddingBottom = padT + "px";
		css.paddingLeft = css.paddingRight = (padT + 2) + "px";
		css = tt_aElt[3].style;
		css.color = tt_aV[TITLEFONTCOLOR];
		if(tt_aV[WIDTH] == -1)
			css.whiteSpace = "nowrap";
		css.fontFamily = tt_aV[TITLEFONTFACE];
		css.fontSize = tt_aV[TITLEFONTSIZE];
		css.fontWeight = "bold";
		css.textAlign = tt_aV[TITLEALIGN];
		// Close button DIV
		if(tt_aElt[4])
		{
			css = tt_aElt[4].style;
			css.background = tt_aV[CLOSEBTNCOLORS][0];
			css.color = tt_aV[CLOSEBTNCOLORS][1];
			css.fontFamily = tt_aV[TITLEFONTFACE];
			css.fontSize = tt_aV[TITLEFONTSIZE];
			css.fontWeight = "bold";
		}
		if(tt_aV[WIDTH] > 0)
			tt_w = tt_aV[WIDTH];
		else
		{
			tt_w = tt_GetDivW(tt_aElt[3]) + tt_GetDivW(tt_aElt[4]);
			// Some spacing between title DIV and closebutton
			if(tt_aElt[4])
				tt_w += pad;
			// Restrict auto width to max width
			if(tt_aV[WIDTH] < -1 && tt_w > -tt_aV[WIDTH])
				tt_w = -tt_aV[WIDTH];
		}
		// Ensure the top border of the body DIV be covered by the title DIV
		iOffY = -wBrd;
	}
	else
	{
		tt_w = 0;
		iOffY = 0;
	}

	//-------- Body DIV ------------
	css = tt_aElt[5].style;
	css.top = iOffY + "px";
	if(wBrd)
	{
		css.borderColor = tt_aV[BORDERCOLOR];
		css.borderStyle = tt_aV[BORDERSTYLE];
		css.borderWidth = wBrd + "px";
	}
	if(tt_aV[BGCOLOR].length)
		css.background = tt_aV[BGCOLOR];
	if(tt_aV[BGIMG].length)
		css.backgroundImage = "url(" + tt_aV[BGIMG] + ")";
	css.padding = pad + "px";
	css.textAlign = tt_aV[TEXTALIGN];
	if(tt_aV[HEIGHT])
	{
		css.overflow = "auto";
		if(tt_aV[HEIGHT] > 0)
			css.height = (tt_aV[HEIGHT] + iAdd) + "px";
		else
			tt_h = iAdd - tt_aV[HEIGHT];
	}
	// TD inside body DIV
	css = tt_aElt[6].style;
	css.color = tt_aV[FONTCOLOR];
	css.fontFamily = tt_aV[FONTFACE];
	css.fontSize = tt_aV[FONTSIZE];
	css.fontWeight = tt_aV[FONTWEIGHT];
	css.textAlign = tt_aV[TEXTALIGN];
	if(tt_aV[WIDTH] > 0)
		w = tt_aV[WIDTH];
	// Width like title (if existent)
	else if(tt_aV[WIDTH] == -1 && tt_w)
		w = tt_w;
	else
	{
		// Measure width of the body's inner TD, as some browsers would expand
		// the container and outer body DIV to 100%
		w = tt_GetDivW(tt_aElt[6]);
		// Restrict auto width to max width
		if(tt_aV[WIDTH] < -1 && w > -tt_aV[WIDTH])
			w = -tt_aV[WIDTH];
	}
	if(w > tt_w)
		tt_w = w;
	tt_w += iAdd;

	//--------- Shadow DIVs ------------
	if(tt_aV[SHADOW])
	{
		tt_w += tt_aV[SHADOWWIDTH];
		iOffSh = Math.floor((tt_aV[SHADOWWIDTH] * 4) / 3);
		// Bottom shadow
		css = tt_aElt[7].style;
		css.top = iOffY + "px";
		css.left = iOffSh + "px";
		css.width = (tt_w - iOffSh - tt_aV[SHADOWWIDTH]) + "px";
		css.height = tt_aV[SHADOWWIDTH] + "px";
		css.background = tt_aV[SHADOWCOLOR];
		// Right shadow
		css = tt_aElt[8].style;
		css.top = iOffSh + "px";
		css.left = (tt_w - tt_aV[SHADOWWIDTH]) + "px";
		css.width = tt_aV[SHADOWWIDTH] + "px";
		css.background = tt_aV[SHADOWCOLOR];
	}
	else
		iOffSh = 0;

	//-------- Container DIV -------
	tt_SetTipOpa(tt_aV[FADEIN] ? 0 : tt_aV[OPACITY]);
	tt_FixSize(iOffY, iOffSh);
}
// Fixate the size so it can't dynamically change while the tooltip is moving.
function tt_FixSize(iOffY, iOffSh)
{
	var wIn, wOut, h, add, pad = tt_aV[PADDING], wBrd = tt_aV[BORDERWIDTH], i;

	tt_aElt[0].style.width = tt_w + "px";
	tt_aElt[0].style.pixelWidth = tt_w;
	wOut = tt_w - ((tt_aV[SHADOW]) ? tt_aV[SHADOWWIDTH] : 0);
	// Body
	wIn = wOut;
	if(!tt_bBoxOld)
		wIn -= (pad + wBrd) << 1;
	tt_aElt[5].style.width = wIn + "px";
	// Title
	if(tt_aElt[1])
	{
		wIn = wOut - ((tt_aV[TITLEPADDING] + 2) << 1);
		if(!tt_bBoxOld)
			wOut = wIn;
		tt_aElt[1].style.width = wOut + "px";
		tt_aElt[2].style.width = wIn + "px";
	}
	// Max height specified
	if(tt_h)
	{
		h = tt_GetDivH(tt_aElt[5]);
		if(h > tt_h)
		{
			if(!tt_bBoxOld)
				tt_h -= (pad + wBrd) << 1;
			tt_aElt[5].style.height = tt_h + "px";
		}
	}
	tt_h = tt_GetDivH(tt_aElt[0]) + iOffY;
	// Right shadow
	if(tt_aElt[8])
		tt_aElt[8].style.height = (tt_h - iOffSh) + "px";
	i = tt_aElt.length - 1;
	if(tt_aElt[i])
	{
		tt_aElt[i].style.width = tt_w + "px";
		tt_aElt[i].style.height = tt_h + "px";
	}
}
function tt_DeAlt(el)
{
	var aKid;

	if(el)
	{
		if(el.alt)
			el.alt = "";
		if(el.title)
			el.title = "";
		aKid = el.childNodes || el.children || null;
		if(aKid)
		{
			for(var i = aKid.length; i;)
				tt_DeAlt(aKid[--i]);
		}
	}
}
// This workaround removes the native tooltips over links in Opera
function tt_OpDeHref(el)
{
	if(!tt_op)
		return;
	if(tt_elDeHref)
		tt_OpReHref();
	while(el)
	{
		if(el.hasAttribute && el.hasAttribute("href"))
		{
			el.t_href = el.getAttribute("href");
			el.t_stats = window.status;
			el.removeAttribute("href");
			el.style.cursor = "hand";
			tt_AddEvtFnc(el, "mousedown", tt_OpReHref);
			window.status = el.t_href;
			tt_elDeHref = el;
			break;
		}
		el = tt_GetDad(el);
	}
}
function tt_OpReHref()
{
	if(tt_elDeHref)
	{
		tt_elDeHref.setAttribute("href", tt_elDeHref.t_href);
		tt_RemEvtFnc(tt_elDeHref, "mousedown", tt_OpReHref);
		window.status = tt_elDeHref.t_stats;
		tt_elDeHref = null;
	}
}
function tt_El2Tip()
{
	var css = tt_t2t.style;

	// Store previous positioning
	tt_t2t.t_cp = css.position;
	tt_t2t.t_cl = css.left;
	tt_t2t.t_ct = css.top;
	tt_t2t.t_cd = css.display;
	// Store the tag's parent element so we can restore that DOM branch
	// when the tooltip is being hidden
	tt_t2tDad = tt_GetDad(tt_t2t);
	tt_MovDomNode(tt_t2t, tt_t2tDad, tt_aElt[6]);
	css.display = "block";
	css.position = "static";
	css.left = css.top = css.marginLeft = css.marginTop = "0px";
}
function tt_UnEl2Tip()
{
	// Restore positioning and display
	var css = tt_t2t.style;

	css.display = tt_t2t.t_cd;
	tt_MovDomNode(tt_t2t, tt_GetDad(tt_t2t), tt_t2tDad);
	css.position = tt_t2t.t_cp;
	css.left = tt_t2t.t_cl;
	css.top = tt_t2t.t_ct;
	tt_t2tDad = null;
}
function tt_OverInit()
{
	if(window.event)
		tt_over = window.event.target || window.event.srcElement;
	else
		tt_over = tt_ovr_;
	tt_DeAlt(tt_over);
	tt_OpDeHref(tt_over);
}
function tt_ShowInit()
{
	tt_tShow.Timer("tt_Show()", tt_aV[DELAY], true);
	if(tt_aV[CLICKCLOSE] || tt_aV[CLICKSTICKY])
		tt_AddEvtFnc(document, "mouseup", tt_OnLClick);
}
function tt_Show()
{
	var css = tt_aElt[0].style;

	// Override the z-index of the topmost wz_dragdrop.js D&D item
	css.zIndex = Math.max((window.dd && dd.z) ? (dd.z + 2) : 0, 1010);
	if(tt_aV[STICKY] || !tt_aV[FOLLOWMOUSE])
		tt_iState &= ~0x4;
	if(tt_aV[DURATION] > 0)
		tt_tDurt.Timer("tt_HideInit()", tt_aV[DURATION], true);
	tt_ExtCallFncs(0, "Show")
	css.visibility = "visible";
	tt_iState |= 0x2;
	if(tt_aV[FADEIN])
		tt_Fade(0, 0, tt_aV[OPACITY], Math.round(tt_aV[FADEIN] / tt_aV[FADEINTERVAL]));
	tt_ShowIfrm();
}
function tt_ShowIfrm()
{
	if(tt_ie56)
	{
		var ifrm = tt_aElt[tt_aElt.length - 1];
		if(ifrm)
		{
			var css = ifrm.style;
			css.zIndex = tt_aElt[0].style.zIndex - 1;
			css.display = "block";
		}
	}
}
function tt_Move(e)
{
	if(e)
		tt_ovr_ = e.target || e.srcElement;
	e = e || window.event;
	if(e)
	{
		tt_musX = tt_GetEvtX(e);
		tt_musY = tt_GetEvtY(e);
	}
	if(tt_iState & 0x04)
	{
		// Prevent jam of mousemove events
		if(!tt_op && !tt_ie)
		{
			if(tt_bWait)
				return;
			tt_bWait = true;
			tt_tWaitMov.Timer("tt_bWait = false;", 1, true);
		}
		if(tt_aV[FIX])
		{
			tt_iState &= ~0x4;
			tt_PosFix();
		}
		else if(!tt_ExtCallFncs(e, "MoveBefore"))
			tt_SetTipPos(tt_Pos(0), tt_Pos(1));
		tt_ExtCallFncs([tt_musX, tt_musY], "MoveAfter")
	}
}
function tt_Pos(iDim)
{
	var iX, bJmpMod, cmdAlt, cmdOff, cx, iMax, iScrl, iMus, bJmp;

	// Map values according to dimension to calculate
	if(iDim)
	{
		bJmpMod = tt_aV[JUMPVERT];
		cmdAlt = ABOVE;
		cmdOff = OFFSETY;
		cx = tt_h;
		iMax = tt_maxPosY;
		iScrl = tt_scrlY;
		iMus = tt_musY;
		bJmp = tt_bJmpVert;
	}
	else
	{
		bJmpMod = tt_aV[JUMPHORZ];
		cmdAlt = LEFT;
		cmdOff = OFFSETX;
		cx = tt_w;
		iMax = tt_maxPosX;
		iScrl = tt_scrlX;
		iMus = tt_musX;
		bJmp = tt_bJmpHorz;
	}
	if(bJmpMod)
	{
		if(tt_aV[cmdAlt] && (!bJmp || tt_CalcPosAlt(iDim) >= iScrl + 16))
			iX = tt_PosAlt(iDim);
		else if(!tt_aV[cmdAlt] && bJmp && tt_CalcPosDef(iDim) > iMax - 16)
			iX = tt_PosAlt(iDim);
		else
			iX = tt_PosDef(iDim);
	}
	else
	{
		iX = iMus;
		if(tt_aV[cmdAlt])
			iX -= cx + tt_aV[cmdOff] - (tt_aV[SHADOW] ? tt_aV[SHADOWWIDTH] : 0);
		else
			iX += tt_aV[cmdOff];
	}
	// Prevent tip from extending past clientarea boundary
	if(iX > iMax)
		iX = bJmpMod ? tt_PosAlt(iDim) : iMax;
	// In case of insufficient space on both sides, ensure the left/upper part
	// of the tip be visible
	if(iX < iScrl)
		iX = bJmpMod ? tt_PosDef(iDim) : iScrl;
	return iX;
}
function tt_PosDef(iDim)
{
	if(iDim)
		tt_bJmpVert = tt_aV[ABOVE];
	else
		tt_bJmpHorz = tt_aV[LEFT];
	return tt_CalcPosDef(iDim);
}
function tt_PosAlt(iDim)
{
	if(iDim)
		tt_bJmpVert = !tt_aV[ABOVE];
	else
		tt_bJmpHorz = !tt_aV[LEFT];
	return tt_CalcPosAlt(iDim);
}
function tt_CalcPosDef(iDim)
{
	return iDim ? (tt_musY + tt_aV[OFFSETY]) : (tt_musX + tt_aV[OFFSETX]);
}
function tt_CalcPosAlt(iDim)
{
	var cmdOff = iDim ? OFFSETY : OFFSETX;
	var dx = tt_aV[cmdOff] - (tt_aV[SHADOW] ? tt_aV[SHADOWWIDTH] : 0);
	if(tt_aV[cmdOff] > 0 && dx <= 0)
		dx = 1;
	return((iDim ? (tt_musY - tt_h) : (tt_musX - tt_w)) - dx);
}
function tt_PosFix()
{
	var iX, iY;

	if(typeof(tt_aV[FIX][0]) == "number")
	{
		iX = tt_aV[FIX][0];
		iY = tt_aV[FIX][1];
	}
	else
	{
		if(typeof(tt_aV[FIX][0]) == "string")
			el = tt_GetElt(tt_aV[FIX][0]);
		// First slot in array is direct reference to HTML element
		else
			el = tt_aV[FIX][0];
		iX = tt_aV[FIX][1];
		iY = tt_aV[FIX][2];
		// By default, vert pos is related to bottom edge of HTML element
		if(!tt_aV[ABOVE] && el)
			iY += tt_GetDivH(el);
		for(; el; el = el.offsetParent)
		{
			iX += el.offsetLeft || 0;
			iY += el.offsetTop || 0;
		}
	}
	// For a fixed tip positioned above the mouse, use the bottom edge as anchor
	// (recommended by Christophe Rebeschini, 31.1.2008)
	if(tt_aV[ABOVE])
		iY -= tt_h;
	tt_SetTipPos(iX, iY);
}
function tt_Fade(a, now, z, n)
{
	if(n)
	{
		now += Math.round((z - now) / n);
		if((z > a) ? (now >= z) : (now <= z))
			now = z;
		else
			tt_tFade.Timer(
					"tt_Fade("
					+ a + "," + now + "," + z + "," + (n - 1)
					+ ")",
					tt_aV[FADEINTERVAL],
					true
			);
	}
	now ? tt_SetTipOpa(now) : tt_Hide();
}
function tt_SetTipOpa(opa)
{
	// To circumvent the opacity nesting flaws of IE, we set the opacity
	// for each sub-DIV separately, rather than for the container DIV.
	tt_SetOpa(tt_aElt[5], opa);
	if(tt_aElt[1])
		tt_SetOpa(tt_aElt[1], opa);
	if(tt_aV[SHADOW])
	{
		opa = Math.round(opa * 0.8);
		tt_SetOpa(tt_aElt[7], opa);
		tt_SetOpa(tt_aElt[8], opa);
	}
}
function tt_OnScrl()
{
	tt_scrlX = tt_GetScrollX();
	tt_scrlY = tt_GetScrollY();
}
function tt_OnCloseBtnOver(iOver)
{
	var css = tt_aElt[4].style;

	iOver <<= 1;
	css.background = tt_aV[CLOSEBTNCOLORS][iOver];
	css.color = tt_aV[CLOSEBTNCOLORS][iOver + 1];
}
function tt_OnLClick(e)
{
	//  Ignore right-clicks
	e = e || window.event;
	if(!((e.button && e.button & 2) || (e.which && e.which == 3)))
	{
		if(tt_aV[CLICKSTICKY] && (tt_iState & 0x4))
		{
			tt_aV[STICKY] = true;
			tt_iState &= ~0x4;
		}
		else if(tt_aV[CLICKCLOSE])
			tt_HideInit();
	}
}
function tt_Int(x)
{
	var y;

	return(isNaN(y = parseInt(x)) ? 0 : y);
}
Number.prototype.Timer = function(s, iT, bUrge)
{
	if(!this.value || bUrge)
		this.value = window.setTimeout(s, iT);
}
Number.prototype.EndTimer = function()
{
	if(this.value)
	{
		window.clearTimeout(this.value);
		this.value = 0;
	}
}
function tt_SetOpa(el, opa)
{
	var css = el.style;

	tt_opa = opa;
	if(tt_flagOpa == 1)
	{
		if(opa < 100)
		{
			// Workarounds for bugs of IE:
			// 1.) Once a CSS filter has been applied, fonts are no longer
			// anti-aliased, so we store the previous 'non-filter' to be
			// able to restore it
			if(typeof(el.filtNo) == tt_u)
				el.filtNo = css.filter;
			// 2.) A DIV cannot be made visible in a single step if an
			// opacity < 100 has been applied while the DIV was hidden
			var bVis = css.visibility != "hidden";
			// 3.) In IE6, applying an opacity < 100 has no effect if the
			//	   element has no layout (position, size, zoom, ...)
			css.zoom = "100%";
			if(!bVis)
				css.visibility = "visible";
			css.filter = "alpha(opacity=" + opa + ")";
			if(!bVis)
				css.visibility = "hidden";
		}
		else if(typeof(el.filtNo) != tt_u)
			// Restore 'non-filter'
			css.filter = el.filtNo;
	}
	else
	{
		opa /= 100.0;
		switch(tt_flagOpa)
		{
		case 2:
			css.KhtmlOpacity = opa; break;
		case 3:
			css.KHTMLOpacity = opa; break;
		case 4:
			css.MozOpacity = opa; break;
		case 5:
			css.opacity = opa; break;
		}
	}
}
function tt_Err(sErr, bIfDebug)
{
//	if(tt_Debug || !bIfDebug)
//		alert("Tooltip Script Error Message:\n\n" + sErr);
}

//============  EXTENSION (PLUGIN) MANAGER  ===============//
function tt_ExtCmdEnum()
{
	var s;

	// Add new command(s) to the commands enum
	for(var i in config)
	{
		s = "window." + i.toString().toUpperCase();
		if(eval("typeof(" + s + ") == tt_u"))
		{
			eval(s + " = " + tt_aV.length);
			tt_aV[tt_aV.length] = null;
		}
	}
}
function tt_ExtCallFncs(arg, sFnc)
{
	var b = false;
	for(var i = tt_aExt.length; i;)
	{--i;
		var fnc = tt_aExt[i]["On" + sFnc];
		// Call the method the extension has defined for this event
		if(fnc && fnc(arg))
			b = true;
	}
	return b;
}

tt_Init();

/*! npm.im/object-fit-images */
var objectFitImages = function () { "use strict"; function t(t) { for (var e, r = getComputedStyle(t).fontFamily, i = {}; null !== (e = c.exec(r)) ;) i[e[1]] = e[2]; return i } function e(e, i) { if (!e[n].parsingSrcset) { var s = t(e); if (s["object-fit"] = s["object-fit"] || "fill", !e[n].s) { if ("fill" === s["object-fit"]) return; if (!e[n].skipTest && l && !s["object-position"]) return } var c = e[n].ios7src || e.currentSrc || e.src; if (i) c = i; else if (e.srcset && !u && window.picturefill) { var o = window.picturefill._; e[n].parsingSrcset = !0, e[o.ns] && e[o.ns].evaled || o.fillImg(e, { reselect: !0 }), e[o.ns].curSrc || (e[o.ns].supported = !1, o.fillImg(e, { reselect: !0 })), delete e[n].parsingSrcset, c = e[o.ns].curSrc || c } if (e[n].s) e[n].s = c, i && (e[n].srcAttr = i); else { e[n] = { s: c, srcAttr: i || f.call(e, "src"), srcsetAttr: e.srcset }, e.src = n; try { e.srcset && (e.srcset = "", Object.defineProperty(e, "srcset", { value: e[n].srcsetAttr })), r(e) } catch (t) { e[n].ios7src = c } } e.style.backgroundImage = 'url("' + c + '")', e.style.backgroundPosition = s["object-position"] || "center", e.style.backgroundRepeat = "no-repeat", /scale-down/.test(s["object-fit"]) ? (e[n].i || (e[n].i = new Image, e[n].i.src = c), function t() { return e[n].i.naturalWidth ? void (e[n].i.naturalWidth > e.width || e[n].i.naturalHeight > e.height ? e.style.backgroundSize = "contain" : e.style.backgroundSize = "auto") : void setTimeout(t, 100) }()) : e.style.backgroundSize = s["object-fit"].replace("none", "auto").replace("fill", "100% 100%") } } function r(t) { var r = { get: function () { return t[n].s }, set: function (r) { return delete t[n].i, e(t, r), r } }; Object.defineProperty(t, "src", r), Object.defineProperty(t, "currentSrc", { get: r.get }) } function i() { a || (HTMLImageElement.prototype.getAttribute = function (t) { return !this[n] || "src" !== t && "srcset" !== t ? f.call(this, t) : this[n][t + "Attr"] }, HTMLImageElement.prototype.setAttribute = function (t, e) { !this[n] || "src" !== t && "srcset" !== t ? g.call(this, t, e) : this["src" === t ? "src" : t + "Attr"] = String(e) }) } function s(t, r) { var i = !A && !t; if (r = r || {}, t = t || "img", a && !r.skipTest) return !1; "string" == typeof t ? t = document.querySelectorAll("img") : "length" in t || (t = [t]); for (var c = 0; c < t.length; c++) t[c][n] = t[c][n] || r, e(t[c]); i && (document.body.addEventListener("load", function (t) { "IMG" === t.target.tagName && s(t.target, { skipTest: r.skipTest }) }, !0), A = !0, t = "img"), r.watchMQ && window.addEventListener("resize", s.bind(null, t, { skipTest: r.skipTest })) } var n = "data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==", c = /(object-fit|object-position)\s*:\s*([-\w\s%]+)/g, o = new Image, l = "object-fit" in o.style, a = "object-position" in o.style, u = "string" == typeof o.currentSrc, f = o.getAttribute, g = o.setAttribute, A = !1; return s.supportsObjectFit = l, s.supportsObjectPosition = a, i(), s }();
/**
 * @preserve
 * Project: Bootstrap Hover Dropdown
 * Author: Cameron Spear
 * Version: v2.1.3
 * Contributors: Mattia Larentis
 * Dependencies: Bootstrap's Dropdown plugin, jQuery
 * Description: A simple plugin to enable Bootstrap dropdowns to active on hover and provide a nice user experience.
 * License: MIT
 * Homepage: http://cameronspear.com/blog/bootstrap-dropdown-on-hover-plugin/
 */
; (function ($, window, undefined) {
    // outside the scope of the jQuery plugin to
    // keep track of all dropdowns
    var $allDropdowns = $();

    // if instantlyCloseOthers is true, then it will instantly
    // shut other nav items when a new one is hovered over
    $.fn.dropdownHover = function (options) {
        // don't do anything if touch is supported
        // (plugin causes some issues on mobile)
        if ('ontouchstart' in document) return this; // don't want to affect chaining

        // the element we really care about
        // is the dropdown-toggle's parent
        $allDropdowns = $allDropdowns.add(this.parent());

        return this.each(function () {
            var $this = $(this),
                $parent = $this.parent(),
                defaults = {
                    delay: 500,
                    hoverDelay: 0,
                    instantlyCloseOthers: true
                },
                data = {
                    delay: $(this).data('delay'),
                    hoverDelay: $(this).data('hover-delay'),
                    instantlyCloseOthers: $(this).data('close-others')
                },
                showEvent = 'show.bs.dropdown',
                hideEvent = 'hide.bs.dropdown',
                // shownEvent  = 'shown.bs.dropdown',
                // hiddenEvent = 'hidden.bs.dropdown',
                settings = $.extend(true, {}, defaults, options, data),
                timeout, timeoutHover;

            $parent.hover(function (event) {
                // so a neighbor can't open the dropdown
                if (!$parent.hasClass('open') && !$this.is(event.target)) {
                    // stop this event, stop executing any code
                    // in this callback but continue to propagate
                    return true;
                }

                openDropdown(event);
            }, function () {
                // clear timer for hover event
                window.clearTimeout(timeoutHover)
                timeout = window.setTimeout(function () {
                    $this.attr('aria-expanded', 'false');
                    $parent.removeClass('open');
                    $this.trigger(hideEvent);
                }, settings.delay);
            });

            // this helps with button groups!
            $this.hover(function (event) {
                // this helps prevent a double event from firing.
                // see https://github.com/CWSpear/bootstrap-hover-dropdown/issues/55
                if (!$parent.hasClass('open') && !$parent.is(event.target)) {
                    // stop this event, stop executing any code
                    // in this callback but continue to propagate
                    return true;
                }

                openDropdown(event);
            });

            // handle submenus
            $parent.find('.dropdown-submenu').each(function () {
                var $this = $(this);
                var subTimeout;
                $this.hover(function () {
                    window.clearTimeout(subTimeout);
                    $this.children('.dropdown-menu').show();
                    // always close submenu siblings instantly
                    $this.siblings().children('.dropdown-menu').hide();
                }, function () {
                    var $submenu = $this.children('.dropdown-menu');
                    subTimeout = window.setTimeout(function () {
                        $submenu.hide();
                    }, settings.delay);
                });
            });

            function openDropdown(event) {
                // clear dropdown timeout here so it doesnt close before it should
                window.clearTimeout(timeout);
                // restart hover timer
                window.clearTimeout(timeoutHover);

                // delay for hover event.  
                timeoutHover = window.setTimeout(function () {
                    $allDropdowns.find(':focus').blur();

                    if (settings.instantlyCloseOthers === true)
                        $allDropdowns.removeClass('open');

                    // clear timer for hover event
                    window.clearTimeout(timeoutHover);
                    $this.attr('aria-expanded', 'true');
                    $parent.addClass('open');
                    $this.trigger(showEvent);
                }, settings.hoverDelay);
            }
        });
    };

    $(document).ready(function () {
        // apply dropdownHover to all elements with the data-hover="dropdown" attribute
        $('[data-hover="dropdown"]').dropdownHover();
    });
})(jQuery, window);
var isKalturaVideoPlaying = false;
var videoKey = null;
var journalShortName = null;
var videoDuration = 0;
var videoTitle = null;

function jsCallbackReady(objectId) {
    window.kdp = document.getElementById(objectId);
    if (window.kdp != null) {
        window.kdp.addJsListener('doPlay', 'KalturaVideoPlayListen');
        window.kdp.addJsListener('playerPlayEnd', 'KalturaVideoPlayEnd');
        window.kdp.addJsListener('firstQuartile', 'KalturaVideoPlayFirstQuartile');
        window.kdp.addJsListener('secondQuartile', 'KalturaVideoPlaySecondQuartile');
        window.kdp.addJsListener('thirdQuartile', 'KalturaVideoPlayThirdQuartile');
    }
}

function KalturaVideoPlayListen(objectId) {
    isKalturaVideoPlaying = true;

    var id = $(this).attr('id');
    var dataDiv = $("div[data-id='" + id + "']");

    videoKey = dataDiv.attr("data-videokey");
    videoDuration = dataDiv.attr("data-videoduration");
    journalShortName = dataDiv.attr("data-journalshortname");
    videoTitle = dataDiv.attr("data-videotitle");

    //If there are multiple videos on page, pause video that is already playing. Don't execute pause if there is only single video.
    if (window.kdp != document.getElementById(objectId)) {
        KalturaVideoPauseSend();
    }

    //Pause the mediaelement audio if it is playing.
    mediaElementPause();

    window.kdp = document.getElementById(objectId);

    //Call to omniture
    Omniture.wkhealth_video('play', videoKey, videoDuration, journalShortName, videoTitle);

    return false;
}

function KalturaVideoPauseSend(e) {
    if (window.kdp != null) {
        window.kdp.sendNotification('pause');
    }
    return false;
}

function KalturaVideoPlayEnd(objectId) {
    //Call to omniture
    Omniture.wkhealth_video('end', videoKey, videoDuration, journalShortName, videoTitle);
}

function KalturaVideoPlayFirstQuartile(objectId) {
    //Call to omniture
    Omniture.wkhealth_video('25', videoKey, videoDuration, journalShortName, videoTitle);
}

function KalturaVideoPlaySecondQuartile(objectId) {
    //Call to omniture
    Omniture.wkhealth_video('50', videoKey, videoDuration, journalShortName, videoTitle);
}

function KalturaVideoPlayThirdQuartile(objectId) {
    //Call to omniture
    Omniture.wkhealth_video('75', videoKey, videoDuration, journalShortName, videoTitle);
}

$(document).ready(function (e) {
    $(".mejs-play").click(function (e) {
        if(isKalturaVideoPlaying) {
            KalturaVideoPauseSend();
        }
    });
});

function mediaElementPause(e) {
    var audioPlayPauseButtons = $('.mejs-playpause-button');
    audioPlayPauseButtons.each(function (e) {
        if ($(this).hasClass('mejs-pause')) {
            var audioElement = $(this).parent().parent().find('audio');
            audioElement.trigger("pause");
        }
    });
}