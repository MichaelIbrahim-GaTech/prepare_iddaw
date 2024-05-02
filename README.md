# Scene Understanding Challenge for Autonomous Navigation in Unstructured Environments


# ICPR-24 Competition on Safe Segmentation of Drive Scenes in Unstructured Traffic and Adverse Weather Condition 

This repository contains the datasets related to safe segmentation challenge for ICPR-24 Competition on Safe Segmentation of Drive Scenes in Unstructured Traffic and Adverse Weather Condition, ICPR 2024 . For more details, please visit https://mobility.iiit.ac.in/safe-seg-24/


## Target datasets:

**For using first add helpers/ to $PYTHONPATH**
```
export PYTHONPATH="${PYTHONPATH}:helpers/"
```

### Dataset Structure 

The structure is similar to the cityscapes dataset. That is:
```
gtFine/{split}/{drive_no}/{img_id}_gtFine_polygons.json for ground truths
leftImg8bit/{split}/{drive_no}/{img_id}_leftImg8bit.png for image frames
```
#### Semantic Segmentation

Furthermore for training, label masks needs to be generated as described below resulting in the following files:
```
gtFine/{split}/{drive_no}/{img_id}_gtFine_labellevel3Ids.png
gtFine/{split}/{drive_no}/{img_id}_gtFine_instancelevel3Ids.png
```
### Labels

See helpers/anue_labels.py

#### Generate Label Masks (for training/evaluation) (Semantic/Instance/Panoptic Segmentation)
```bash
python preperation/createLabels.py --datadir $ANUE --id-type $IDTYPE --color [True|False] --instance [True|False] --num-workers $C
```

- ANUE is the path to the AutoNUE dataset
- IDTYPE can be id, csId, csTrainId, level3Id, level2Id, level1Id. 
- color True  generates the color masks
- instance True generates the instance masks with the id given by IDTYPE
- panoptic True generates panoptic masks in the format similar to COCO. See the modified evaluation scripts here: https://github.com/AutoNUE/panopticapi
- C is the number of threads to run in parallel


For the supervised domain adaptation and semantic segmentation tasks, the masks should be generated using IDTYPE of level3Id and used for training models (similar to trainId in cityscapes). This can be done by the command:
```bash
python preperation/createLabels.py --datadir $ANUE --id-type level3Id --num-workers $C
```


The generated files:

- _gtFine_labelLevel3Ids.png will be used for semantic segmentation


## Viewer

First generate label masks as described above. To view the ground truths / prediction masks at different levels of heirarchy use:
```bash
python viewer/viewer.py ---datadir $ANUE
```

- ANUE has the folder path to the dataset or prediction masks with similar file/folder structure as dataset.

TODO: Make the color map more sensible.


## Evaluation

### Semantic Segmentation

First generate labels masks with level3Ids as described before. Then
```bash
python evaluate/evaluate_mIoU.py --gts $GT  --preds $PRED  --num-workers $C
```

- GT is the folder path of ground truths containing <drive_no>/<img_no>_gtFine_labellevel3Ids.png 
- PRED is the folder paths of predictions with the same folder structure and file names.
- C is the number of threads to run in parallel


### Constrained Semantic Segmentation

First generate labels masks with level1Ids as described before. Then
```bash
python evaluate/idd_lite_evaluate_mIoU.py --gts $GT  --preds $PRED  --num-workers $C
```

- GT is the folder path of ground truths containing <drive_no>/<img_no>_gtFine_labellevel1Ids.png 
- PRED is the folder paths of predictions with the same folder structure and file names.
- C is the number of threads to run in parallel


### Instance Segmentation


First generate instance label masks with ID_TYPE=id, as described before. Then
```bash
python evaluate/evaluate_instance_segmentation.py --gts $GT  --preds $PRED 
```

- GT is the folder path of ground truths containing <drive_no>/<img_no>_gtFine_labellevel3Ids.png 
- PRED is the folder paths of predictions with the same folder structure and file names. The format for predictions is the same as the cityscapes dataset. That is a .txt file where each line is of the form "<instance_mask_png> <label id> <conf score>". Note that the ID_TYPE=id is used by this evaluation code.
- C is the number of threads to run in parallel

### Panoptic Segmentation

Please use https://github.com/AutoNUE/panopticapi

### Detection

```bash
python evaluate/evaluate_detection.py --gts $GT  --preds $PRED 
```
- GT is the folder path of ground truths containing Annotations/<capture_category>/<drive sequence>/<>.xml
- PRED is the folder path of predictions with generated outputs in idd_det_<image_set>_<level3Id>.txt format. Here image_set can take {train,val,test}, while level3Id for all trainable labels has to present.



## Acknowledgement

Some of the code was adapted from the cityscapes code at: https://github.com/mcordts/cityscapesScripts/ 
Some of the code was adapted from https://github.com/rbgirshick/py-faster-rcnn
Some of the code was adapted from https://github.com/cocodataset/panopticapi

