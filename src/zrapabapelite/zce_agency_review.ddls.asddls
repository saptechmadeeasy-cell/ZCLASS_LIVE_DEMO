@EndUserText.label: 'Agency Review'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_CE_DEMO'
define custom entity ZCE_AGENCY_REVIEW
{
@UI.lineItem: [{ position: 10, label: 'Agency ID' }]
  key AgencyID      : /dmo/agency_id;
  @UI.lineItem: [{ position: 10, label: 'ReviewID' }]
  key ReviewID : abap.int4;
  @UI.lineItem: [{ position: 10, label: 'Score (1-5)' }]
  ReviewScore       : abap.int1;
  @UI.lineItem: [{ position: 20, label: 'Review Comment' }]
  ReviewText        : abap.char(100);
  @UI.lineItem: [{ position: 30, label: 'Date Updated' }]
  LastUpdated       : abap.dats;
}
