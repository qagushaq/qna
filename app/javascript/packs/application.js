require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")
require("skim")
require("gon")
global.jQuery, global.$ = require("jquery");

require ("utilities/answer_edit_form")
require ("utilities/question_edit_form")
require ("utilities/vote")

import "bootstrap"
import "cocoon-js-vanilla";
