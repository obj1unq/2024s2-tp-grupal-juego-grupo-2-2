import wollok.game.*
import posiciones.*
import extras.*
import paleta.*
import enemigos.*
import armas.*
import randomizer.*
import pelea.*

object mapa {
    //podemos hacer const tablero que represente todas las celdas del tablero y eso usarlo para dibujar los distintos elementos del mismo.
    //Eso lo usaríamos para dibujar cada elemento en su posición con un método para dibujar todas las celdas del tablero y métodos
    //individuales que dibujen los distintos objetos (onda, uno para arma, uno para enemigo) (como hizo Leo en clase hace un tiempo)

    /* esto es ineficiente!
    method limpiar() {
        (0..game.width()-1).forEach({ x =>
            (0..game.height()-1).forEach({ y =>
                game.getObjectsIn(game.at(x,y)).forEach({obj => if(!self.estaEnOrigin(obj.position())) {game.removeVisual(obj)} })
            })
        })
    }
    */

    method limpiar() {
        game.allVisuals().forEach({vis => if(!self.estaEnOrigin(vis.position())) {game.removeVisual(vis)} })

    }

    method estaEnOrigin(pos) {
        return pos == game.at(0,0)
    }

}