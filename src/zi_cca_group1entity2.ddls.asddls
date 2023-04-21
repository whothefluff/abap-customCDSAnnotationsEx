@AbapCatalog.sqlViewName: 'ZICCAGRP1ENTY2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Some data with custom CDS annotations'
@zGroup1: true
define view ZI_CCA_Group1Entity2
  as select from I_UnitOfMeasure
  {
    UnitOfMeasure,
    UnitOfMeasureDimension,
    UnitOfMeasureISOCode,
    UnitOfMeasureNumberOfDecimals,
    UnitOfMeasureDspNmbrOfDcmls,
    UnitOfMeasure_E,
    _Dimension,
    _DimensionText,
    _Text
  }
  where UnitOfMeasure = I_UnitOfMeasure.UnitOfMeasure_E
