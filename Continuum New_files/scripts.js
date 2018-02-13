var domain = window.location.hostname;
domain = domain.substring(domain.indexOf(".") + 1);

var closeModal = function () {
    if (domain === "neurology.org") {
        document.getElementById("page").style.display = "block";
    }

    document.getElementsByTagName("body")[0].classList.remove("modal-active-publications");
};


document.querySelector(".publications button").addEventListener("click", function () {

    document.getElementsByTagName("body")[0].classList.add("modal-active-publications");

    var modal = document.getElementsByClassName('.modal-publications');
    modal.scrollTop = 0;

    if (domain === "neurology.org") {
        document.getElementById("page").style.display = "none";
    }
});

document.addEventListener("keyup", function (e) {
    if (e.keyCode === 27) {
        closeModal();
    }
});

document.getElementsByClassName("btn-close")[0].addEventListener("click", function () {
    closeModal();
});

//AAN.nav_universal = function () {

//    var namespace = 'header';

    //var $doc = $(document);
    //var $body = $('body');
    //var $nav = $('.nav-universal-container');
    //var $btnSiteSearch = $nav.find('.btn-site-search');
    //var btnSiteSearchTextDefault = $btnSiteSearch.text();
    //var btnSiteSearchTextHide = 'Hide Search';
    //var $siteSearch = $nav.find('.site-search-container');
    //var $btnPublications = $nav.find('.publications button')
    //var $modal = $('.modal-publications');
    //var $btnModalClose = $modal.find('.btn-close');

    //var domain = window.location.hostname;
    //domain = domain.substring(domain.indexOf(".") + 1);

    //var closeModal = function () {
    //    if (domain === "neurology.org") {
    //        $("#page").show();
    //    }

    //    $body.removeClass('modal-active-publications');
    //    //$modal.siblings().each(function () {
    //    //    $(this)[0].inert = false;
    //    //});
    //    //$btnPublications.focus();
    //    //$doc.off('keyup.publicationsModal');
    //};

    //$btnPublications.on('click', function () {
    //    //console.log("pubs clicked");
    //    $body.addClass('modal-active-publications');
    //    $modal.scrollTop(0);
    //    $modal.siblings().each(function () {
    //        $(this)[0].inert = true;
    //    });
    //    $btnModalClose.focus();

    //    if (domain === "neurology.org") {
    //        $("#page").hide();
    //    }

    //    $doc.on('keyup.publicationsModal', function (e) {
    //        if (e.keyCode === 27) {
    //            closeModal();
    //        }
    //    });
    //});

    //$btnModalClose.on('click', function () {
    //    //console.log("pubs closed clicked");
    //    closeModal();
    //});



//    init = function () {



//        var closeModal = function () {
//            if (domain === "neurology.org") {
//                $("#page").show();
//            }

//            $body.removeClass('modal-active-publications');
//            $modal.siblings().each(function () {
//                $(this)[0].inert = false;
//            });
//            $btnPublications.focus();
//            $doc.off('keyup.publicationsModal');
//        };

//        $btnPublications.on('click', function () {
//            console.log("pubs clicked");
//            $body.addClass('modal-active-publications');
//            $modal.scrollTop(0);
//            $modal.siblings().each(function () {
//                $(this)[0].inert = true;
//            });
//            $btnModalClose.focus();

//            if (domain === "neurology.org") {
//                $("#page").hide();
//            }

//            $doc.on('keyup.publicationsModal', function (e) {
//                if (e.keyCode === 27) {
//                    closeModal();
//                }
//            });
//        });

//        $btnModalClose.on('click', function () {
//            console.log("pubs closed clicked");
//            closeModal();
//        });

//        $btnSiteSearch.on('click', function () {
//            var $btn = $(this);
//            if ($nav.hasClass('search-active')) {
//                $nav.removeClass('search-active');
//                $siteSearch.fadeOut('fast');
//                $btn.text(btnSiteSearchTextDefault);
//            }
//            else {
//                $nav.addClass('search-active');
//                $btn.text(btnSiteSearchTextHide);
//                $siteSearch.fadeIn('fast');
//                $siteSearch.find('input[type="search"]').eq(0).focus();
//            }
//        });

//    };

//    self.init();

//}(jQuery);

//AAN.alert = function () {

//    var $alert = $('#main').find('.alert-container');

//    init = function () {

//        $alert.each(function () {
//            var $this = $(this);
//            $this.find('.btn-close').on('click', function () {
//                $this.remove();
//            });
//        });
//    };

//    if ($alert.length) {
//        self.init();
//    }

//}(jQuery);

//AAN.seeMore = function () {

//    var $seeMoreItems = $('.see-more');

//    function init() {
//        // loop through each see more item on the page
//        $seeMoreItems.each(function (i, el) {
//            $(el).data('initialheight', $(el).find('.text').height());
//            $(el).on('click', 'button', function () {
//                toggle(el);
//            });

//            // append the button
//            $(el).append($('<button />')
//                .attr('aria-expanded', false)
//                .text($(el).data('showmorelabel'))
//                .attr('aria-label', $(this).data('aria-label-show'))
//            );
//        });
//    }

//    function toggle(el) {

//        var initialHeight = $(el).data('initialheight');
//        var expandedHeight = $(el).find('.text-inner').innerHeight();

//        // if the component is open
//        if ($(el).hasClass('is-open')) {

//            $(el).find('.text').animate({
//                height: initialHeight
//            });

//            $(el).find('button')
//                .attr('aria-expanded', false)
//                .attr('aria-label', $(el).data('aria-label-show'))
//                .text($(el).data('showmorelabel'));

//            // if the component is closed
//        } else {

//            $(el).find('.text').animate({
//                height: expandedHeight
//            }, function () {
//                $(el).find('.text').css({
//                    height: 'auto'
//                });
//            });

//            $(el).find('button')
//                .attr('aria-expanded', true)
//                .attr('aria-label', $(el).data('aria-label-hide'))
//                .text($(el).data('showlesslabel'));
//        }

//        // toggle the is-open class
//        $(el).toggleClass('is-open');

//    }

//    $(function () {
//        // if there are see more items on the page
//        if ($seeMoreItems.length > 0) {
//            init();
//        }
//    });

//}(jQuery);
//AAN.descriptionScroll = function () {

//    var $scrollFollow = $('.scroll-follow'),
//        $window = $(window),
//        topPadding = $('.hdr-global').length > 0 ? $('.hdr-global').outerHeight() + 20 : 70,
//        breakpoint = 960;


//    init = function () {
//        if ($window.width() > breakpoint) {
//            $scrollFollow.each(function () {
//                var params = {
//                    element: $(this),
//                    elementOffset: $(this).offset(),
//                    parentHeight: $(this).parent().innerHeight(),
//                    elementHeight: $(this).outerHeight(),
//                    topPadding: topPadding
//                };

//                // Attaching event handler
//                $window.scroll(params, scrollFollow);
//                // Triggering handler once to align scroll-follow elements if page reloaded
//                if ($window.scrollTop() > 0) {
//                    $window.triggerHandler('scroll');
//                }
//            });
//        } else {

//            // Cleaning up event handler and removing style attributes
//            $scrollFollow.each(function () {
//                $(this).removeAttr('style');
//            });
//            $window.off('scroll', scrollFollow);
//        }
//    };

//    function scrollFollow(event) {
//        if (event.currentTarget.scrollY > (event.data.elementOffset.top - event.data.topPadding)
//            && (event.currentTarget.scrollY - event.data.elementOffset.top + topPadding < (event.data.parentHeight - event.data.elementHeight))) {
//            event.data.element.css({
//                marginTop: event.currentTarget.scrollY - event.data.elementOffset.top + event.data.topPadding
//            });
//        }
//        else if (event.currentTarget.scrollY < (event.data.elementOffset.top - event.data.topPadding)) {
//            event.data.element.css({
//                marginTop: 0
//            })
//        }
//    }

//    $(function () {
//        // if there are items with scroll-follow on the page
//        if ($scrollFollow.length > 0) {
//            $window.resize(function () {
//                init();
//            });
//            init();
//        }
//    });

//}(jQuery);
