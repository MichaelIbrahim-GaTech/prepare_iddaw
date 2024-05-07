
# ICPR-24 Competition on Safe Segmentation of Drive Scenes in Unstructured Traffic and Adverse Weather Condition

This repository contains the datasets related to safe segmentation challenge for ICPR-24 Competition on Safe Segmentation of Drive Scenes in Unstructured Traffic and Adverse Weather Condition, ICPR 2024 . For more details, please visit https://mobility.iiit.ac.in/safe-seg-24/

## Installing requirements

Firstly install the required libraries using

```
pip install -r requirements.txt
```

## Target datasets:

**For using first add helpers/ to $PYTHONPATH**
```
export PYTHONPATH="${PYTHONPATH}:helpers/"
```

### Dataset Structure

The structure is similar to the IDD dataset. That is:
```
gtFine/{split}/{drive_no}/{img_id}_gtFine_mask.json for ground truths
leftImg8bit/{split}/{drive_no}/{img_id}_rgb.png for image frames
```
#### Semantic Segmentation

Furthermore for training, label masks needs to be generated as described below resulting in the following files:
```
gtFine/{split}/{drive_no}/{img_id}_gtFine_labellevel3Ids.png
```
### Labels

See helpers/anue_labels.py

#### Generate Label Masks (for training/evaluation) (Semantic/Instance/Panoptic Segmentation)
```bash
python preperation/createLabels_iddaw.py --datadir $IDDAW --id-type $IDTYPE --color [True|False] --num-workers $C
```

- IDDAW is the path to the IDD-AW dataset
- IDTYPE can be id, csId, csTrainId, level3Id, level2Id, level1Id.
- color True  generates the color masks
- C is the number of threads to run in parallel

<!--
For the supervised domain adaptation and semantic segmentation tasks, the masks should be generated using IDTYPE of level3Id and used for training models (similar to trainId in cityscapes). This can be done by the command:
```bash
python preperation/createLabels.py --datadir $ANUE --id-type level3Id --num-workers $C
``` -->


The generated files:

- _gtFine_labelLevel3Ids.png will be used for semantic segmentation


## Viewer

First generate label masks as described above. To view the ground truths / prediction masks at different levels of heirarchy use:
```bash
python viewer/viewer.py ---datadir $ANUE
```

- ANUE has the folder path to the dataset or prediction masks with similar file/folder structure as dataset.

TODO: Make the color map more sensible.

<!--
## Evaluation

### Semantic Segmentation

First generate labels masks with level3Ids as described before. Then
```bash
python evaluate/evaluate_mIoU.py --gts $GT  --preds $PRED  --num-workers $C
```

- GT is the folder path of ground truths containing <drive_no>/<img_no>_gtFine_labellevel3Ids.png
- PRED is the folder paths of predictions with the same folder structure and file names.
- C is the number of threads to run in parallel

 -->
