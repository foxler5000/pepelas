package game.events.custom;

import game.events.Event.EventCall;
import game.states.PlayState;

/**
 * Evento personalizado para cambiar el escenario (stage) a mitad de la canción.
 */
class ChangeStage extends EventCall
{
    /**
     * Esta función se llama cuando el evento se activa en la canción.
     * @param lemming El estado principal del juego (PlayState).
     * @param eventData Los datos del evento definidos en el JSON.
     */
    override public function onCall(lemming:PlayState, eventData:Map<String, Dynamic>):Void
    {
        // Obtenemos el nombre del nuevo escenario del objeto de datos del evento.
        var newStageName:String = eventData.get('newStage');

        // Verificamos que el nombre del escenario no esté vacío.
        if (newStageName != null && newStageName.trim() != '')
        {
            trace('Changing stage to: ' + newStageName);

            // --- Lógica para cambiar el escenario ---
            // Esta es la parte que puede variar mucho dependiendo del motor.
            // La idea general es:
            // 1. Eliminar los elementos del escenario actual.
            // 2. Cargar los elementos del nuevo escenario.

            // Ejemplo hipotético (puede que necesites cambiar esto):
            
            // Primero, podrías necesitar limpiar el grupo de objetos del escenario actual.
            // El motor podría tener un grupo llamado 'stageGroup' o 'backgroundGroup'.
            if (lemming.members.contains(lemming.stageGroup))
            {
                lemming.remove(lemming.stageGroup, true);
                lemming.stageGroup.destroy();
            }

            // Luego, creas el nuevo escenario. El motor podría tener una función para esto.
            // Es posible que tengas que llamar a una función que cargue un escenario por su nombre.
            // La función podría estar en PlayState o en una clase de ayuda.
            // Por ejemplo:
            // lemming.createStage(newStageName);

            // Si no existe una función simple, tendrías que recrear los objetos manualmente.
            // Por ejemplo:
            // var newBackground = new FlxSprite().loadGraphic(Paths.image('stages/' + newStageName + '/background'));
            // lemming.add(newBackground);

            // Es MUY recomendable que busques en el código de PlayState.hx del Codename Engine
            // cómo se carga el escenario al principio de la canción para replicar esa lógica aquí.
        }
        else
        {
            trace('Error: newStage name is null or empty.');
        }
    }
}