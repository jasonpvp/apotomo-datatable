var preInitFuncs=[];
var postInitFuncs=[];
//load other scripts
//$.getScript('assets/jquery.dataTables.js');

$("<link/>", {
   rel: "stylesheet",
   type: "text/css",
   href: "assets/apotomo-datatable.css"
}).appendTo("head");


$(document).ready(function() {
  //call pre-init functions in order
  $.each(preInitFuncs, function(index,funcSet) {
    funcSet[0](funcSet[1]);
  });

  //automatically call controller/action specific function if it exists
  //'if ($.isFunction('+controller.controller_name + '_' + controller.action_name+')) {'+controller.controller_name + '_' + controller.action_name + '()}');
  try {
    view_func=controller.controller_name + '_' + controller.action_name;
    eval('if ($.isFunction('+view_func+')) {'+view_func + '()}');
  }
  catch (err) {
    //view_func is not defined
  }

  //call post-init functions in order
  $.each(postInitFuncs, function(index,funcSet) {
    funcSet[0](funcSet[1]);
  });
});

function preInit(func,args) {
  //Usage: preInit(function(args) {...},args);
  //preInit functions run before a view-action specific function runs and before postInit functions
  //but order of preInit function execution is not guaranteed
  if ($.isFunction(func)) {
    preInitFuncs.push([func,args])
  }
}

function postInit(func,args) {
  //Usage: postInit(function(args) {...},args);
  //postInit functions run after preInit and view-action specific functions
  //order of postInit function execution is not guaranteed
  if ($.isFunction(func)) {
    postInitFuncs.push([func,args])
  }
}
