import Gio from 'gi://Gio';
import Mtk from 'gi://Mtk';
import Shell from 'gi://Shell';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';

const IFACE = `<node><interface name="org.mnicolas.Pointer">
  <method name="Get"><arg type="i" direction="out"/><arg type="i" direction="out"/></method>
  <method name="ToggleGhostty"/>
</interface></node>`;

const GHOSTTY_ID = 'com.mitchellh.ghostty.desktop';

function pointerMonitor() {
    const [x, y] = global.get_pointer();
    return global.display.get_monitor_index_for_rect(new Mtk.Rectangle({x, y, width: 1, height: 1}));
}

function bringTo(win, monitor) {
    const ws = global.workspace_manager.get_active_workspace();
    if (win.minimized)
        win.unminimize();
    if (!win.is_on_all_workspaces() && win.get_workspace() !== ws)
        win.change_workspace(ws);
    if (win.get_monitor() !== monitor)
        win.move_to_monitor(monitor);
    if (!win.is_maximized()) {
        // estilo guake: arriba, ancho completo, mitad de alto
        const area = win.get_work_area_for_monitor(monitor);
        win.move_resize_frame(true, area.x, area.y, area.width, Math.round(area.height / 2));
    }
    win.activate(global.get_current_time());
}

function toggleGhostty() {
    const app = Shell.AppSystem.get_default().lookup_app(GHOSTTY_ID);
    const monitor = pointerMonitor();
    const wins = app?.get_windows() ?? []; // ordenadas por uso más reciente

    if (wins.length === 0) {
        const id = global.display.connect('window-created', (_d, win) => {
            if (win.get_wm_class() !== 'com.mitchellh.ghostty')
                return;
            global.display.disconnect(id);
            const sid = win.connect('shown', () => {
                win.disconnect(sid);
                bringTo(win, monitor);
            });
        });
        app.open_new_window(-1);
        return;
    }

    const win = wins[0];
    if (win.has_focus() && !win.minimized && win.get_monitor() === monitor)
        win.minimize();
    else
        bringTo(win, monitor);
}

export default class PointerDbus extends Extension {
    enable() {
        this._impl = Gio.DBusExportedObject.wrapJSObject(IFACE, {
            Get: () => { const [x, y] = global.get_pointer(); return [x, y]; },
            ToggleGhostty: () => toggleGhostty(),
        });
        this._impl.export(Gio.DBus.session, '/org/mnicolas/Pointer');
        this._owner = Gio.bus_own_name(Gio.BusType.SESSION, 'org.mnicolas.Pointer',
            Gio.BusNameOwnerFlags.NONE, null, null, null);
    }

    disable() {
        this._impl.unexport();
        Gio.bus_unown_name(this._owner);
        this._impl = null;
    }
}
