jsi18n = (function() {
    var translations = {};

    return {
        get: function() {
            if(arguments.length < 2) return arguments[0];

            // grep string
            var nspace = arguments[0];
            var id = arguments[1];
            var text;
            if(translations[nspace]) {
                text = translations[nspace][id];
            }
            if(typeof text !== 'string') text = id;

            // replace [_1] with arguments[2] etc.
            var i;
            for(i = 2; i < arguments.length; i++) {
                text = text.replace('[_'+(i-1)+']', arguments[i]);
            }

            return text;
        },
        add: function(nspace, toadd) {
            if(typeof nspace !== 'string' || nspace === 'expand') {
                if(console && console.log) console.log("wrong name-space");
                return;
            }
            if(typeof toadd !== 'object') {
                // XXX JSON.parse?
                if(console && console.log) console.log("wrong translations");
                return;
            }
            if(translations[nspace]) {
                var old = translations[nspace];
                for (var attrname in toadd) { old[attrname] = toadd[attrname]; }
            } else {
                translations[nspace] = toadd;
            }
            // XXX only add strings
        },
        dump: function(what) {
            var todump = (what)?translations[what]:translations;
            return JSON.stringify(todump);
        }
    };
})();

if(window.foswiki) window.foswiki.jsi18n = jsi18n;
