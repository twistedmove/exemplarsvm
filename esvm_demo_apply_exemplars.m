function esvm_demo_apply_exemplars(imageset, models, M)
%In this application demo, we apply the ensemble of Exemplar-SVMs
%represented by [models,M] onto the sequence of images [imageset]

if isfield(models{1},'I') && isstr(models{1}.I) && length(models{1}.I)>=7 ...
      && strcmp(models{1}.I(1:7),'http://')
  fprintf(1,['Warning: Models have images as URLs\n -- If you want' ...
             ' to apply detectors to a LOT of images, download the' ...
              ' PASCAL VOC2007 dataset locally and call :\n   [models]=esvm_update_voc_models(models,local_dir);\n']);
end


if ~exist('M','var')
  M = [];
end

if ~iscell(imageset) 
  if isnumeric(imageset)
    imageset = {imageset};
  end
end

params = esvm_get_default_params;

for i = 1:length(imageset)
  local_detections = esvm_detect_imageset(imageset(i), models, ...
                                          params);

  result_struct = esvm_apply_calibration(local_detections, models, M, params);

  maxk = 1;
  allbbs = esvm_show_top_dets(result_struct, local_detections, ...
                              imageset(i), models, ...
                              params,  maxk);
  drawnow
  snapnow
end