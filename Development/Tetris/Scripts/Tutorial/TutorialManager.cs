﻿using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;
 
/// ゲーム上のチュートリアルを管理するマネージャクラス

public class TutorialManager : MonoBehaviour
{
    // チュートリアル用UI
    protected RectTransform tutorialTextArea;
    protected Text TutorialTitle;
    protected Text TutorialText;
 
    // チュートリアルタスク
    protected ITutorialTask currentTask;
    protected List<ITutorialTask> tutorialTask;
 
    // チュートリアル表示フラグ
    private bool isEnabled;
 
    // チュートリアルタスクの条件を満たした際の遷移用フラグ
    private bool task_executed = false;
 
    // チュートリアル表示時のUI移動距離
    private float fade_pos_x = 800.0f;

    GameObject _startButton;
    void Start()
    {
        _startButton = GameObject.Find("Help");
    }
    public void IvokeTutorial()
    {
        _startButton.GetComponent<Button>().interactable = false;
         // チュートリアル表示用UIのインスタンス取得
        tutorialTextArea = GameObject.Find("TutorialTextArea").GetComponent<RectTransform>();
        TutorialTitle = tutorialTextArea.Find("Title").GetComponent<Text>();
        TutorialText = tutorialTextArea.Find("Text").GetComponentInChildren<Text>();
 
        // チュートリアルの一覧
        tutorialTask = new List<ITutorialTask>()
        {
            new Tutorial1(),
            new Tutorial2(),
            new Tutorial3(),
        };
 
        // 最初のチュートリアルを設定
        StartCoroutine(SetCurrentTask(tutorialTask.First()));
        isEnabled = true;
    }

 
    void Update()
    {
        // チュートリアルが存在し実行されていない場合に処理
        if (currentTask != null && !task_executed) {
            // 現在のチュートリアルが実行されたか判定
            if (currentTask.CheckTask()) {
                task_executed = true;
                Debug.Log(tutorialTask.Count+"2");
                DOVirtual.DelayedCall(currentTask.GetTransitionTime(), () => {
                    iTween.MoveTo(tutorialTextArea.gameObject, iTween.Hash(
                        "position", tutorialTextArea.transform.localPosition + new Vector3(fade_pos_x, 0, 0),
                        "time", 0.3f,
                        "isLocal", true
                    ));
 
                    tutorialTask.RemoveAt(0);
 
                    var nextTask = tutorialTask.FirstOrDefault();
                    if (nextTask != null) {
                        StartCoroutine(SetCurrentTask(nextTask, 0.3f));
                    }
                    else
                    {
                        _startButton.GetComponent<Button>().interactable = true;
                    }
                });
            }
        }
 
        if (Input.GetKey(KeyCode.A)) {
            SwitchEnabled();
        }
    }

    /// 新しいチュートリアルタスクを設定する
   
    protected IEnumerator SetCurrentTask(ITutorialTask task, float time = 0)
    {
        // timeが指定されている場合は待機
        yield return new WaitForSeconds(time);
 
        currentTask = task;
        task_executed = false;
 
        // UIにタイトルと説明文を設定
        TutorialTitle.text = task.GetTitle();
        TutorialText.text = task.GetText();
 
        // チュートリアルタスク設定時用の関数を実行
        task.OnTaskSetting();
 
        iTween.MoveTo(tutorialTextArea.gameObject, iTween.Hash(
            "position", tutorialTextArea.transform.localPosition - new Vector3(fade_pos_x, 0, 0),
            "time", 0.3f,
            "isLocal", true
        ));
    }
 
    /// チュートリアルの有効・無効の切り替え
  
    protected void SwitchEnabled()
    {
        isEnabled = !isEnabled;
 
        // UIの表示切り替え
        float alpha = isEnabled ? 1f : 0;
        tutorialTextArea.GetComponent<CanvasGroup>().alpha = alpha;
    }
}