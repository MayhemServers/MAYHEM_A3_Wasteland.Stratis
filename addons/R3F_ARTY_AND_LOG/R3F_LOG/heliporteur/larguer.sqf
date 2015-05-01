/**
 * Larguer un objet en train d'être héliporté //Dropping an object being heli
 *
 * @param 0 l'héliporteur
 *
 * Copyright (C) 2010 madbull ~R3F~
 *
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

if (R3F_LOG_mutex_local_verrou) then
{
	player globalChat STR_R3F_LOG_mutex_action_en_cours;
}
else
{
	R3F_LOG_mutex_local_verrou = true;

	private ["_heliporteur", "_objet", "_airdrop"];

	_heliporteur = _this select 0;
	_objet = _heliporteur getVariable "R3F_LOG_heliporte";
	_parachute = [_this, 3, false, [false]] call BIS_fnc_param;

	// On mémorise sur le réseau que le véhicule n'héliporte plus rien // Is stored on the network that the vehicle is nothing more heli
	_heliporteur setVariable ["R3F_LOG_heliporte", objNull, true];
	// On mémorise aussi sur le réseau que l'objet n'est plus attaché// It also stores on the network that the subject is no longer attached
	_objet setVariable ["R3F_LOG_est_transporte_par", objNull, true];

	if (_parachute) then
	{
		pvar_parachuteLiftedVehicle = netId _objet;
		publicVariableServer "pvar_parachuteLiftedVehicle";
	}
	else
	{
		_airdrop = (vectorMagnitude velocity _heliporteur > 15 || (getPos _heliporteur) select 2 > 40);

		if (local _objet) then
		{
			[_objet, _airdrop] call detachTowedObject;
		}
		else
		{
			pvar_detachTowedObject = [netId _objet, _airdrop];
			publicVariable "pvar_detachTowedObject";
		};
	};

	player globalChat format [STR_R3F_LOG_action_heliport_larguer_fait, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];

	R3F_LOG_mutex_local_verrou = false;
};
