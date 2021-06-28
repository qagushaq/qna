import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "bootstrap"
import "cocoon-js-vanilla";

Rails.start()
Turbolinks.start()
ActiveStorage.start()

require("action_cable")
require("jquery")
require("cocoon")
require("skim")
global.jQuery, global.$ = require("jquery");

require ("utilities/answer_edit_form")
require ("utilities/question_edit_form")
require ("utilities/vote")
require ("utilities/comment_channel")

let App = App || {}
App.cable = ActionCable.createConsumer();
