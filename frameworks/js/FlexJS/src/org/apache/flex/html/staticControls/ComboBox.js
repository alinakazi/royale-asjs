/**
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org.apache.flex.html.staticControls.ComboBox');

goog.require('org.apache.flex.core.UIBase');


/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html.staticControls.ComboBox = function() {
    org.apache.flex.core.UIBase.call(this);
    
    /**
     * @private
     * @type {Array.<Object>}
     */
    this._dataProvider;
};
goog.inherits(
    org.apache.flex.html.staticControls.ComboBox, org.apache.flex.core.UIBase
);

/**
 * @override
 * @this {org.apache.flex.html.staticControls.ComboBox}
 * @param {Object} p The parent element.
 */
org.apache.flex.html.staticControls.ComboBox.prototype.addToParent = 
    function(p) {
	this.element = document.createElement('div');
	
	var input = document.createElement('input');
	this.element.appendChild(input);
	
	var box = document.createElement('select');
	box.onchange = this.selectChanged;
	this.element.appendChild(box);
	
	this.element.style.position = "relative";
	input.style.width = "100px";
	input.style["float"] = "left";
	box.style["float"] = "left";
	
    p.appendChild(this.element);

    this.positioner = this.element;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.ComboBox}
 */
org.apache.flex.html.staticControls.ComboBox.prototype.selectChanged =
function() {
	var box = this.parentNode.childNodes.item(1);
	var input = this.parentNode.childNodes.item(0);
	input.value = box.value;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.ComboBox}
 * @return {Array.<Object>} The collection of data.
 */
org.apache.flex.html.staticControls.ComboBox.prototype.get_dataProvider =
function() {
    return this._dataProvider;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.ComboBox}
 * @param {Array.<Object>} value The text setter.
 */
org.apache.flex.html.staticControls.ComboBox.prototype.set_dataProvider =
function(value) {
    this._dataProvider = value;

	var box = this.element.childNodes.item(1);
    var dp = box.options;
    var n = dp.length;
    for (var i = 0; i < n; i++)
        dp.remove(0);

    n = value.length;
    for (i = 0; i < n; i++)
    {
        var opt = document.createElement('option');
        opt.text = value[i];
        dp.add(opt);
    }
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.ComboBox}
 * @return {int} The selected index.
 */
org.apache.flex.html.staticControls.ComboBox.prototype.get_selectedIndex =
function() {
    return this.element.childNodes.item(1).selectedIndex;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.ComboBox}
 * @param {int} value The selected index.
 */
org.apache.flex.html.staticControls.ComboBox.prototype.set_selectedIndex =
function(value) {
    this.element.childNodes.item(1).selectedIndex = value;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.ComboBox}
 * @return {Object} The selected item.
 */
org.apache.flex.html.staticControls.ComboBox.prototype.get_selectedItem =
function() {
    return this._dataProvider[this.element.childNodes.item(1).selectedIndex];
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.ComboBox}
 * @param {Object} value The selected item.
 */
org.apache.flex.html.staticControls.ComboBox.prototype.set_selectedItem =
function(value) {

    var dp = this._dataProvider;
    var n = dp.length;
    for (var i = 0; i < n; i++)
    {
        if (dp[i] == value)
            break;
    }
    if (i < n) {
        this.element.childNodes.item(1).selectedIndex = i;
        this.element.childNodes.item(0).value = this._dataProvider[i];
    }
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.ComboBox}
 * @return {string} The text getter.
 */
org.apache.flex.html.staticControls.ComboBox.prototype.get_text = function() {
    return this.element.childNodes.item(0).value;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.ComboBox}
 * @param {string} value The text setter.
 */
org.apache.flex.html.staticControls.ComboBox.prototype.set_text = function(value) {
    this.element.childNodes.item(0).value = value;
};
