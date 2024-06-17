/* extension.js
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

/* exported init */


import GObject from 'gi://GObject';

import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';

import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import * as PopupMenu from 'resource:///org/gnome/shell/ui/popupMenu.js';
import * as QuickSettings from 'resource:///org/gnome/shell/ui/quickSettings.js';

import {DisplayScaleSwitcher} from './dbus.js';

const LAST_SCALE_KEY = 'last-selected-display-scale';

// Round scale values to multiple of 25 % just like Gnome Settings
function scaleToPercentage(scale) {
    return Math.floor(scale * 4 + 0.5) * 25;
}

const DisplayScaleQuickMenuToggle = GObject.registerClass(
    class DisplayScaleQuickMenuToggle extends QuickSettings.QuickMenuToggle {

        _init(settings) {
            // Set QuickMenu name and icon
            super._init({
                title: 'Display Scale',
                iconName: 'video-display-symbolic',
                toggleMode: true,
            });
            this.menu.setHeader('video-display-symbolic', 'Display Scale');
            
            this.settings = settings;
            
            this._displayScaleSwitcher = new DisplayScaleSwitcher();
            this._displayScaleSwitcher.connect('state-changed', () => {
                this._updateDisplayList();
            });
            
            this.connect('clicked', () => {
                const newScale = this.checked
                    ? this.settings.get_double(LAST_SCALE_KEY)
                    : 1.0;
                this._displayScaleSwitcher.setDisplayScale(newScale);
            });
        }

        _addDummyItem(message) {
            const item = new PopupMenu.PopupMenuItem(message);
            item.label.get_clutter_text().set_line_wrap(true);
            this.menu.addMenuItem(item);
        }
        
        _updateCurrentScale(scale) {
            this.title = 'Scale: ' + scaleToPercentage(scale) + ' %';
            
            this.checked = scaleToPercentage(scale) !== 100;
            
            if (this.checked) {
                this.settings.set_double(LAST_SCALE_KEY, scale);
            }
        }

        _updateDisplayList() {
            this.menu.removeAll();

            const displays = this._displayScaleSwitcher.getDisplayInfo();

            if (displays === null) {
                this._addDummyItem('Unable to get display info.');
                return;
            }

            // Current version only supports single display.
            if (displays.length > 1) {
                this._addDummyItem('Multiple displays detected. This is not supported by the extension.');
                return;
            }
            else {
                const display = displays[0];

                for (let scale of display.scales) {
                    const scaleItem = new PopupMenu.PopupMenuItem(scaleToPercentage(scale) + ' %');
                    
                    scaleItem.connect('activate', () => {
                        this._displayScaleSwitcher.setDisplayScale(scale);
                    });

                    scaleItem.setOrnament(scale === display.currentScale
                        ? PopupMenu.Ornament.CHECK
                        : PopupMenu.Ornament.NONE);
        
                    this.menu.addMenuItem(scaleItem);
                }
                
                this._updateCurrentScale(display.currentScale);
            }
        }
    });

export default class DisplayScaleSwitcherExtension extends Extension {
    enable() {
        this._indicator = new QuickSettings.SystemIndicator();
        this._indicator.quickSettingsItems.push(new DisplayScaleQuickMenuToggle(this.getSettings()));
        Main.panel.statusArea.quickSettings.addExternalIndicator(this._indicator);
    }

    disable() {
        this._indicator.quickSettingsItems.forEach(item => item.destroy());
        this._indicator.destroy();
        this._indicator = null;
    }
}
