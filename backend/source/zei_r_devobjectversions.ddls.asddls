@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reuse View for Development Object Vers.'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZEI_R_DevObjectVersions
  as select from vrsd
{
  key objtype    as ABAPObjectType,
  key objname    as ABAPObject,
  key versno     as VersionNumber,
      korrnum    as VersionRequestNumber,
      author     as CreatedBy,
      datum      as CreatedOn,
      zeit       as CreatedAt,
      loekz      as IsDeleted,
      origin     as Origin,
      versmode   as VersionCreationType,
      lastversno as LastVersionNumber,
      firstversn as FirstVersionNumber,
      rels       as ReleaseNumber,
      mandt      as Client,
      keylen     as KeyLengthOfTable,
      tablen     as WidthOfTable,
      defversno  as ObjectDefinitionVersionNumber,
      full_vers  as HasFullVersion,
      archived   as IsArchived
}
