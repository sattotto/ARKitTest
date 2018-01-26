//
//  ViewController.swift
//  ARTestApp
//
//  Created by satoto on 2018/01/15.
//  Copyright © 2018年 佐藤秀輔. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import RealmSwift

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var memoText: String?
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        let memos: Results<MemoNode>
        
        memos = realm.objects(MemoNode.self)
        memoUpdate(memoNodes: memos)
        
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func createMemo(_ sender: Any) {
        //setMemoToScene(memo: "hoge")
        self.performSegue(withIdentifier: "create", sender: nil)
    }
    
    private func createMemoNode(_ memo:String, position:SCNVector3) -> SCNNode {
        let node = SCNNode()
        let scale: CGFloat = 0.3
        
        let memoLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 24*memo.count, height: 24))
        memoLabel.textAlignment = .center
        memoLabel.text = memo
        memoLabel.textColor = UIColor.black
        memoLabel.font = UIFont.systemFont(ofSize: 24)
        
        let memoView = UIView(frame: CGRect(x: 0, y: 0, width: memoLabel.frame.width, height: memoLabel.frame.height))
        memoView.backgroundColor = UIColor.clear
        memoView.addSubview(memoLabel)
        
        let geometry = SCNBox(width: memoView.frame.width * scale / memoView.frame.height, height: scale, length: 0.00000001, chamferRadius: 0.0)
        geometry.firstMaterial?.diffuse.contents = memoView
        
        node.geometry = geometry
        node.position = position
        node.name = "memo"
        return node
    }
    
    private func setMemoToScene(memo: String){
        if let camera = sceneView.pointOfView {
            let position = SCNVector3(0, 0, -5)
            let convertPosition = camera.convertPosition(position, to: nil)
            let node = createMemoNode(memo, position: convertPosition)
            node.eulerAngles = camera.eulerAngles
            
            let realm = try! Realm()
            
            let memoNode = MemoNode()
            memoNode.cameraPosX = convertPosition.x
            memoNode.cameraPosY = convertPosition.y
            memoNode.cameraPosZ = convertPosition.z
            memoNode.eulerAnglesX = camera.eulerAngles.x
            memoNode.eulerAnglesY = camera.eulerAngles.y
            memoNode.eulerAnglesZ = camera.eulerAngles.z
            memoNode.memoText = memo
            try! realm.write {
                realm.add(memoNode)
            }
            
            self.sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    @IBAction func unwindToFirstView(segue: UIStoryboardSegue) {
        if memoText != "" {
            setMemoToScene(memo: memoText!)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: sceneView) else {
            return
        }
        if let hitResults = self.sceneView?.hitTest(location, options: nil) {
            if hitResults.count > 0 {
                let result = hitResults.first?.node
                
                if result?.name == "memo" {
                    tapMemoAlert(result: result!)
                }
            }
        }
    }
    
    // メモタップ時のアラート
    private func tapMemoAlert(result: SCNNode) {
        let alertController = UIAlertController(title: "メッセージの編集",message: "", preferredStyle: UIAlertControllerStyle.alert)
        
//        let edit = UIAlertAction(title: "編集する", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
//            print("edit!")
//        }
        let delete = UIAlertAction(title: "削除する", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
            print("delete!")
            result.removeFromParentNode()
        }
        let cancelButton = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: nil)
        
//        alertController.addAction(edit)
        alertController.addAction(delete)
        alertController.addAction(cancelButton)
        
        present(alertController,animated: true,completion: nil)
    }
    
    private func memoUpdate(memoNodes: Results<MemoNode>){
        for memoNode in memoNodes {
            setMemoToScene(memo: memoNode.memoText, memoNode: memoNode)
        }
    }
    
    private func setMemoToScene(memo: String, memoNode: MemoNode){
        if let camera = sceneView.pointOfView {
            camera.position.x = memoNode.cameraPosX
            camera.position.y = memoNode.cameraPosY
            camera.position.z = memoNode.cameraPosZ
            let position = SCNVector3(0, 0, -5)
            let convertPosition = camera.convertPosition(position, to: nil)
            let node = createMemoNode(memo, position: convertPosition)
            
            let angle = SCNVector3(memoNode.eulerAnglesX,memoNode.eulerAnglesY,memoNode.eulerAnglesZ)
            
            node.eulerAngles = angle
            
            self.sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/

}
