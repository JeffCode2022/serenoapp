import '../models/codigo_ocurrencia_model.dart';
import '../models/codigo_radio_model.dart';

class PdfCodesSeed {
  static List<CodigoOcurrencia> get ocurrenciasMininter {
    return [
      CodigoOcurrencia()
        ..codigo = '010101'
        ..descripcion = 'PRESUNTO HOMICIDIO'
        ..categoria = 'VIDA, EL CUERPO Y LA SALUD',
      CodigoOcurrencia()
        ..codigo = '010301'
        ..descripcion = 'PRESUNTO ROBO A PERSONAS (CELULARES, MOCHILAS, CARTERAS)'
        ..categoria = 'CONTRA EL PATRIMONIO',
      CodigoOcurrencia()
        ..codigo = '010308'
        ..descripcion = 'PRESUNTO DAÑO (DAÑAR, DESTRUIR O INUTILIZAR BIEN MUEBLE O INMUEBLE)'
        ..categoria = 'CONTRA EL PATRIMONIO',
      CodigoOcurrencia()
        ..codigo = '010313'
        ..descripcion = 'PRESUNTO HURTO DE VEHÍCULOS (MAYORES Y MENORES)'
        ..categoria = 'CONTRA EL PATRIMONIO',
      CodigoOcurrencia()
        ..codigo = '020401'
        ..descripcion = 'PRESUNTO CONSUMO DE ALCOHOL O DROGAS PERTURBANDO LA TRANQUILIDAD'
        ..categoria = 'CONTRA LAS BUENAS COSTUMBRES',
      CodigoOcurrencia()
        ..codigo = '030111'
        ..descripcion = 'VEHÍCULOS ESTACIONADOS EN ZONA PROHIBIDA'
        ..categoria = 'INFRACCIONES AL TRÁNSITO',
      CodigoOcurrencia()
        ..codigo = '030305'
        ..descripcion = 'PRESUNTAS PERSONAS EN ACTITUD SOSPECHOSA'
        ..categoria = 'TRANQUILIDAD Y EL ORDEN',
      // Nota: Aquí se ingresarán los más de 100 códigos restantes del PDF.
    ];
  }

  static List<CodigoRadio> get indicativosRadio {
    return [
      CodigoRadio()..codigo = '10-00'..significado = 'DISPONIBLE',
      CodigoRadio()..codigo = '10-02'..significado = 'EN SERVICIO / PATRULLAJE',
      CodigoRadio()..codigo = '10-03'..significado = 'EMERGENCIA',
      CodigoRadio()..codigo = '10-04'..significado = 'SOLICITO INFORMACIÓN',
      CodigoRadio()..codigo = '10-05'..significado = 'CUAL ES SU UBICACIÓN',
      CodigoRadio()..codigo = '10-08'..significado = 'CON PRECAUCIÓN',
      CodigoRadio()..codigo = '10-09'..significado = 'COMPRENDIDO',
      CodigoRadio()..codigo = '10-10'..significado = 'SIN NOVEDAD',
      CodigoRadio()..codigo = '10-14'..significado = 'POSITIVO',
      CodigoRadio()..codigo = '10-50'..significado = 'SOLICITO APOYO / REFUERZOS',
      CodigoRadio()..codigo = '10-60'..significado = 'SOSPECHOSO',
      CodigoRadio()..codigo = '10-62'..significado = 'DETENIDO / RETENIDO',
      CodigoRadio()..codigo = '10-104'..significado = 'ATROPELLO',
      CodigoRadio()..codigo = '10-105'..significado = 'CHOQUE',
      CodigoRadio()..codigo = '10-166'..significado = 'AGRESIÓN AL SERENO',
      // Nota: Aquí se ingresarán los códigos de radio restantes del PDF.
    ];
  }
}
