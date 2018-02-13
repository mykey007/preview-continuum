var ejpcaptcha = ejpcaptcha || {}; //namespace for ejpcaptcha
ejpcaptcha.renderQueue = []; //queue to add the container ids in case grecaptcha resources have not yet loaded

//this function name is passed as onload querystring parameter while calling the recaptcha api.js ex.onload=onGrecaptchaLoad
var onGrecaptchaLoad = function () {
    //console.log("onGrecaptchaLoad: recaptcha resources loaded!");

    //grecaptcha loaded call the rendercaptcha method for any items in queue
    while (ejpcaptcha.renderQueue.length > 0) {
        var recaptchaContainerId = ejpcaptcha.renderQueue.shift();
        renderCaptcha(recaptchaContainerId);
    }
};

var renderCaptcha = function (recaptchaContainerIdentifier) {

    //if grecaptcha is not available add the recaptchaContainerIdentifier to queue
    if (typeof grecaptcha === 'undefined') {
        ejpcaptcha.renderQueue.push(recaptchaContainerIdentifier);
        return;
    }

    //validate
    if (!recaptchaContainerIdentifier) {
        throw new Error("recaptchaContainerIdentifier missing");
    }

    //get the recaptcha container element
    var recaptchaDevContainer = $('#' + recaptchaContainerIdentifier);

    if (recaptchaDevContainer.length === 0) {
        throw new Error("Element with id " + recaptchaContainerIdentifier + " not found.");
    }
    else if (recaptchaDevContainer.length > 1) {
        throw new Error("Found more than one element with id " + recaptchaContainerIdentifier + ". It must be unique.");
    }

    //the captcha container has data-uniqueclassidentifier attribute that stores the unique class name to identify the button the submits a form
    var formSubmitTriggeringElementIdentifier = recaptchaDevContainer.attr('data-uniqueclassidentifier');
    var formSubmitTriggeringElement = $("." + formSubmitTriggeringElementIdentifier);

    if (formSubmitTriggeringElement.length === 0) {
        throw new Error("Element with class "+formSubmitTriggeringElementIdentifier+" not found");
    }

    var overrideCaptchaOptions = {};

    //if no callback has been provided add a default one. 
    if (!recaptchaDevContainer.attr('data-callback')) {

        //This function will be called after after grecaptcha.execute completes execution
        overrideCaptchaOptions.callback = (function (targetElement) {
            return function () {
                //grecaptcha execution complete. remove validation flag
                targetElement.removeAttr("data-validate");

                //trigger the click event of the button
                targetElement.trigger("click");
            };
        })(formSubmitTriggeringElement);
    }

    //render the recaptcha and get the recaptcha widget id
    var recaptchaId = grecaptcha.render(recaptchaDevContainer.attr('id'), overrideCaptchaOptions, true);

    //console.log("grecaptcha.render called");
    //console.log("recaptcha id: " + recaptchaId);
    
    //set a property on the form submission element ex. the button the widget id that is passed to grecaptcha.execute()
    formSubmitTriggeringElement.attr("data-recaptchawidgetid", recaptchaId);

    /*
     * set a flag to indicate whether client side validation is required or not. First time the button 
     * is clicked perform client validation and then call grecaptcha.execute(). The callback will 
     * remove the flag and trigger the click event causing the client side validation to be called again.
     * The validation function can this time skip validation
     */
    formSubmitTriggeringElement.attr("data-validate", "1"); 
};




//var renderCaptcha = function (uniqueClassIdentifier) {

//    if (!uniqueClassIdentifier) {
//        throw new Error("uniqueClassIdentifier missing");
//    }
//    else if ($('.' + uniqueClassIdentifier).length === 0) {
//        throw new Error("element with class " + uniqueClassIdentifier + " not found.");
//    }
//    else if ($('.' + uniqueClassIdentifier).length > 1) {
//        throw new Error("Found more than one element with class " + uniqueClassIdentifier + ". Expecting just one.");
//    }

//    console.log("onGrecaptchaLoad: recaptcha resources loaded!");

//    var containerId = 'div-recaptcha-' + uniqueClassIdentifier;
//    var recaptchaDevContainer = $('#'+containerId);

//    if (recaptchaDevContainer.length === 0) {
//        throw new Error("Unable to find the recaptcha container div with id "+containerId);
//    }

//    var recaptchaId = grecaptcha.render(recaptchaDevContainer.attr('id'),
//        {
//            //sitekey: recaptchaDevContainer.attr('data-sitekey'),
//            //callback: recaptchaDevContainer.attr('data-callback'),
//            //badge: recaptchaDevContainer.attr('data-badge'),
//            //size: recaptchaDevContainer.attr('data-size'),
//            //type: recaptchaDevContainer.attr('data-type')
//        },
//        true);

//    console.log("grecaptcha.render called");
//    console.log("recaptcha id: " + recaptchaId);
//    $("."+uniqueClassIdentifier).attr("data-recaptchawidgetid", recaptchaId);
//    $("."+uniqueClassIdentifier).attr("data-validate", "1");
//};






//$(document)
//    .ready(function () {
//        console.log("loaded!");
//        $(".grecaptcha-execute").click(function () {
//            console.log("button clicked");

//            var grecaptchaExecutedPrevStatus = grecaptchaExecuted;

//            if (grecaptchaExecutedPrevStatus !== true) {
//                grecaptcha.execute();
//                console.log("grecaptcha.execute called");
//            } else {
//                grecaptchaExecuted = false;
//            }

//            return grecaptchaExecutedPrevStatus;
//        });
//    });




//$(document)
//    .ready(function () {
//        console.log("loaded!");
//        $(".grecaptcha-execute").click(function () {
//            console.log("button clicked");

//            console.log("data-recaptcha-id", $(this).attr("data-recaptcha-id"));

//            var grecaptchaExecutedPrevStatus = grecaptchaExecuted;

//            if (grecaptchaExecutedPrevStatus !== true) {
//                grecaptcha.execute($(this).attr("data-recaptcha-id"));
//                console.log("grecaptcha.execute called");
//            } else {
//                grecaptchaExecuted = false;
//            }

//            return grecaptchaExecutedPrevStatus;
//        });
//    });

