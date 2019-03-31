var chineseConv = require('chinese-conv');
 
module.exports = {
        do: function(str){
            return chineseConv.sify(str)
        }
    }

