let Notificaciones = function() {
    let notificaciones = [];
    let contenedorArribaIzquierda = null;
    let contenedorArribaDerecha = null;
    let contenedorAbajoIzquierda = null;
    let contenedorAbajoDerecha = null;

    const duracionMsDefault = 2500;

    let _Notificar = function(config) {
        _CrearNotificacion(config);
    };

    let _CrearNotificacion = function(config) {
        let notificacion = {
            id: Date.now().getTime(),
            duracionMs: config.duracion || duracionMsDefault,
            contenido: config.contenido,
            tipo: config.tipo || TiposNotificacion.Default,
            tema: config.tema || TemasNotificacion.Default,
            posicion: config.posicion || PosicionesNotificacion.Default,
            html: config.html,
            elemento: null,
            click: config.click,
            confirm: config.confirm,
            confirmText: config.confirmText || "Si",
            cancel: config.cancel,
            cancelText: config.cancelText || "No",
        };

        _GenerarContenedores();
        _GenerarHtmlNotificacion(notificacion);
        _MostrarNotificacion(notificacion);

        notificaciones.push(notificacion);
    };

    let _GenerarContenedores = function() {
        if(contenedorArribaIzquierda && contenedorArribaDerecha && contenedorAbajoIzquierda && contenedorAbajoDerecha) return;

        contenedorArribaIzquierda = $('<div class="contenedor-notificaciones-arriba-izquierda"></div>');
        contenedorArribaDerecha = $('<div class="contenedor-notificaciones-arriba-derecha"></div>');
        contenedorAbajoIzquierda = $('<div class="contenedor-notificaciones-abajo-izquierda"></div>');
        contenedorAbajoDerecha = $('<div class="contenedor-notificaciones-abajo-derecha"></div>');

        $('#container').append(contenedorArribaIzquierda).append(contenedorArribaDerecha).append(contenedorAbajoIzquierda).append(contenedorAbajoDerecha);
    };

    let _GenerarHtmlNotificacion = function(notificacion) {
        let html = '';
        html += '<div id="notificaion-' + notificacion.id + '" class="notificacion ' + notificacion.tema + ' ' + notificacion.posicion + ' visible">';
        if(notificacion.html) html += notificacion.html
        else html += '   <div class="contenido-notificacion"><p class="texto-notificacion">' + notificacion.contenido + '</p></div>';
        if(notificacion.tipo == TiposNotificacion.Confirmacion) {
            html += '<div class="botones-notificacion">';
            html += '   <button class="noti-confirm">' + notificacion.confirmText + '</button>';
            html += '   <button class="noti-cancel">' + notificacion.cancelText + '</button>';
            html += '</div>';
        }
        html += '</div>';

        notificacion.elemento = $(html);
    };

    let _MostrarNotificacion = function(notificacion) {
        switch(notificacion.posicion) {
            case PosicionesNotificacion.ArribaIzquierda:
                contenedorArribaIzquierda.append(notificacion.elemento);
                break;
            case PosicionesNotificacion.ArribaDerecha:
                contenedorArribaDerecha.append(notificacion.elemento);
                break;
            case PosicionesNotificacion.AbajoIzquierda:
                contenedorAbajoIzquierda.append(notificacion.elemento);
                break;
            case PosicionesNotificacion.AbajoDerecha:
                contenedorAbajoDerecha.append(notificacion.elemento);
                break;
            default:
                break;
        }

        if(notificacion.click) notificacion.elemento.click(function() {
            notificacion.click();
            notificacion.elemento.removeClass('visible');
            setTimeout(function() {
                notificacion.elemento.remove();
            }, 500);
        });

        if(notificacion.tipo == TiposNotificacion.Confirmacion) {
            notificacion.elemento.find('.noti-confirm').click(function() {
                if(notificacion.confirm) notificacion.confirm();
                notificacion.elemento.removeClass('visible');
                setTimeout(function() {
                    notificacion.elemento.remove();
                }, 500);
            });

            notificacion.elemento.find('.noti-cancel').click(function() {
                if(notificacion.cancel) notificacion.cancel();
                notificacion.elemento.removeClass('visible');
                setTimeout(function() {
                    notificacion.elemento.remove();
                }, 500);
            });
        } else {
            setTimeout(function() {
                notificacion.elemento.removeClass('visible');
                setTimeout(function() {
                    notificacion.elemento.remove();
                }, 500);
            }, notificacion.duracionMs);
        }
    };

    return {
        Notificar: _Notificar
    };
}();

const TiposNotificacion = {
    Default: 1,
    Mensaje: 1,
    Confirmacion: 2
};

const TemasNotificacion = {
    Default: 'tema-primario',
    Primario: 'tema-primario',
    Exito: 'tema-exito',
    Alerta: 'tema-alerta',
    Error: 'tema-error'
};

const PosicionesNotificacion = {
    Default: 'abajo-derecha',
    ArribaIzquierda: 'arriba-izquierda',
    ArribaDerecha: 'arriba-derecha',
    AbajoIzquierda: 'abajo-izquierda',
    AbajoDerecha: 'abajo-derecha'
};