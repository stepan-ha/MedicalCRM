//ResourceCenterController

//Lightning imports
import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//Components imports

//External library 

// Icons now handled by c-rc-icon using a static resource zip named 'ResourceIcons'

//apex class
import getItemsInFolder from '@salesforce/apex/SharepointController.openFolder'
import previewItem from '@salesforce/apex/SharepointController.previewItem'
// keep only required apex imports
 


export default class SharepointDocuments extends LightningElement {
    
  @track data = [];
  @track masterData = [];

    @api recordId;
    @api path;

    @track selectedData = [];

    siteId = 'artemderid.sharepoint.com,ebd087e5-532b-4c57-934c-6673a63d3d52,a32ed421-a7a9-4f21-9e45-c38b42a2250d';
    driveId = 'b!5YfQ6ytTV0yTTGZzpj09UiHULqOppyFPnkXDi0KiJQ1b2gyRC66AQLE2c01onFq6';

    TOKEN = '';

    @track folderPath = [
    ];


    get currentFolder(){
      return this.folderPath[this.folderPath.length-1]?.id;
    }

    loaded = true;

    get isselected(){
        if(this.selectedData.length>0)
            return false;
        else
            return true;
    }

    parseResponce(dataToProcess){
        dataToProcess.forEach(item=>{
            item.nameToDisplay = item.name.length<55?item.name:item.name.slice(0,54)+'...';
            item.hiden = false;
            item.createdDateTime = new Date(item.createdDateTime).toLocaleDateString('en-us', { weekday:"long", year:"numeric", month:"short", day:"numeric"});
            item.lastModifiedBy = 'Stepan Halaiko';
            if(item.folder!=null||item.folder!=undefined){
                item.iconName = 'folder.png';
            }
            else if (item.downloadUrl!=null||item.downloadUrl!=undefined){
                if(item.file.mimeType.includes("application/vnd.openxmlformats-officedocument.wordprocessingml.document")
                ||item.file.mimeType.includes("application/msword")){
                    item.iconName = 'docx.png';
                }
                else if(item.file.mimeType.includes("image/jpeg")||item.file.mimeType.includes("image/png")){
                    item.iconName = 'photo.png';
                }
                else if(item.file.mimeType.includes("application/pdf")){
                    item.iconName = 'pdf.png';
                }
                else if(item.file.mimeType.includes("text/plain") || item.file.mimeType.includes('application/rtf')){
                  item.iconName = 'txt.png';
                }
                else if(item.file.mimeType.includes("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
                ||item.file.mimeType.includes("text/csv")
                || item.file.mimeType.includes("application/vnd.ms-excel")){
                  item.iconName = 'xlsx.png';
                }
                else if(item.file.mimeType.includes("application/vnd.openxmlformats-officedocument.presentationml.presentation")){
                  item.iconName = 'pptx.png';
                }
                else if(item.file.mimeType.includes('application/x-rar-compressed') 
                || item.file.mimeType.includes('application/x-7z-compressed') 
                || item.file.mimeType.includes('application/octet-stream')
                || item.file.mimeType.includes('application/json')){
                    item.iconName = 'zip.png';
                }
                else if(item.file.mimeType.includes('text/html')){
                  item.iconName = 'mailIcon.png';
                }
            }
            item.boxStyle = "item";
        })

        console.log(dataToProcess);

        return dataToProcess?dataToProcess:[];
    }

    parseItems(siteId, driveId, folderId){
      console.log("getItemsInFolder");
      getItemsInFolder({siteId: siteId, driveId: driveId, folderId: folderId})
      .then(result =>{
        console.log("result: ", JSON.stringify(result));
        if(result==null){
          this.showToast('Помилка', 'Щось пішло не так, зверніться до адміністратора', 'error');
          return;
        }
        
        this.masterData = this.parseResponce(result.value); 
        this.data = [...this.masterData]; 

        this.loaded = false;
      })
    }

    connectedCallback(){
        console.log("openFolder");
        this.openFolder({id:'01SSC7HZVKSF2OMZANFJHZJGK57IBK3AU5', name:'New Folder Test'});
        
    }
    

    reload(folderId){
        this.parseItems(this.siteId, this.driveId, folderId, this.TOKEN);
    }

    // Removed move/copy features (modals not available)

    downloadFile(fileUrl, targetValue){
      window.open(fileUrl, targetValue);
    }

    handleDownload(event){
      let filesUrls = [];

      this.selectedData.forEach(item=>{
        if(item.downloadUrl!=null||item.downloadUrl!=undefined){
          filesUrls.push(item.downloadUrl);
        }
      })
      
       let targetBoolean = true;
       filesUrls.forEach(async element=>{
        await this.downloadFile(element, targetBoolean?'_blank':'_self');
        targetBoolean=!targetBoolean;
       })

    }

    async extendPath(folder){
      let pathCopy = this.folderPath;
      pathCopy.push({name:folder.name, id:folder.id});
      this.folderPath = [];
      this.folderPath = pathCopy;
    }

    async reducePath(folder){
      let pathCopy = this.folderPath;
      this.folderPath = [];
      while(true){
        let element = pathCopy.pop();
        if(element.id == folder.id){
          pathCopy.push(element);
          break;
        }
      }
      this.folderPath = pathCopy;
    }

    openFolder(folder, isPath){
      this.loaded = true;
      this.data = [];
      console.log("parseItems");
      console.log("this.siteId: ", this.siteId);
      console.log("this.driveId", this.driveId);
      console.log("folder.id", folder.id);
      this.parseItems(this.siteId, this.driveId, folder.id);
      if(isPath)
          this.reducePath(folder)
        else
          this.extendPath(folder);
      this.selectedData = [];
    }

    openFile(file){
      window.open(file.webUrl, '_blank');
    }

    openPreview(file){
        let itemId = file.id;
        previewItem({siteId: this.siteId, driveId: this.driveId, itemId: itemId, token: this.TOKEN})
        .then(output=>{
            if(output==null){
              this.showToast('Помилка', 'Щось пішло не так, зверніться до адміністратора', 'error');
              return;
            }
            let previewItem = output;
            console.log(previewItem);
            window.open(previewItem.getUrl, '_blank');
        })
        .catch(error=>{
            console.error(error);
        })
    }

    handleRenameItem(event){
        let itemId = event.target.dataset.id;
        createFolderModal.open({
            size: 'medium',
            label: 'Перейменувати папку',
            buttonLabel: 'Перейменувати',
            bodyLabel: 'Введіть назву папки',
            inputType: 'text',
            oldValue: this.data.filter(item=>item.id === itemId)[0].name
          }).then((result) => {
              if (result==null){
                  return
              }
                renameItem({siteId: this.siteId, driveId: this.driveId, itemId: itemId, token: this.TOKEN, newName: result})
                .then(output=>{
                    this.reload(this.folderPath[this.folderPath.length-1].id);
                    this.showToast('Успіх', 'Елемент успішно перейменовано!', 'success');
                })
                .catch(error=>{
                    console.error(error);
                })
          });
    }

    handleDeleteItem(event){
        let item = this.data.filter(item=>item.id === event.target.dataset.id)[0];
        let toModal = [];
        toModal.push(item);
        confirmationModal.open({
            size: 'medium',
            type: 'Видалити',
            items: toModal
          })
          .then((result) => {
              if(result){
                deleteItem({siteId: this.siteId, driveId: this.driveId, itemId: item.id, token: this.TOKEN})
                .then(output=>{
                    this.reload(this.folderPath[this.folderPath.length-1].id);
                    this.showToast('Успіх', 'Елемент успішно видалено!', 'success');
                })
                .catch(error=>{
                    console.error(error);
                })
              }
          });
    }

    handleEditItem(event){
        let file = this.data.filter(item => item.id=== event.target.dataset.id)[0];
        this.openFile(file);
    }

    /*handleShareItem(event){
        let file = this.data.filter(item => item.id=== event.target.dataset.id)[0];
        shareModal.open({
            size: 'medium',
            label: 'Share ' + file.name + ' with',
            buttonLabel: 'Share',
            bodyLabel: 'Enter email:',
          })
          .then(result => {
            console.log('res: ', result);
            if (result==null)
                return
            shareItem({siteId: this.siteId, driveId: this.driveId, itemId: file.id, token: this.TOKEN, shareWith: result.emails, isEdit: result.isEdit})
            .then(output=>{
            this.showToast('Success', file.name + ' was successfully share with ' + result.emails, 'success');
          })
          
          })
    }*/

    /*handleKeyUp(event){
      const isEnterKey = event.keyCode === 13;
      let queryTerm = '';
      if (isEnterKey) {
          queryTerm = event.target.value;
          this.queryTerm = queryTerm;
      }
    }*/

    /*cancelSearchHandler(event){
      console.log('cancelSearchHandler');
      this.queryTerm = undefined;
      const inputElement = this.template.querySelector('.search-input');
      if (inputElement) {
        inputElement.value = '';
      }
    }*/


    handlerOpen(event){
      let itemId = event.target.dataset.id;
      let item = this.data.filter(element=>element.id==itemId)[0];

      if(item.folder!=null||item.folder!=undefined){
        this.openFolder(item, false);
      }
      else if(item.downloadUrl!=null||item.downloadUrl!=undefined){
        this.openPreview(item);
      }
    }

    goToPathHandler(event){
        let itemId = event.target.dataset.id;
        let item = this.folderPath.filter(element=>element.id===itemId)[0];
        console.log(item);
        this.openFolder(item, true);
      }

    selectItemHandler(event){
      let itemId = event.target.dataset.id;
      if(this.selectedData.some(element=>element.id === itemId)){
        this.selectedData = this.selectedData.filter(element=>element.id !== itemId);
        this.data = this.data.map(d=> d.id===itemId ? { ...d, selected: false } : d);
      } else {
        const found = this.data.find(element=>element.id === itemId);
        if(found){
          this.selectedData = [...this.selectedData, found];
          this.data = this.data.map(d=> d.id===itemId ? { ...d, selected: true } : d);
        }
      }
    }

    get rowActions(){
      return ['Відкрити','Завантажити'];
    }

    get selectedPdfItems(){
      return this.selectedData
        .filter(it=> it.file && it.file.mimeType && it.file.mimeType.includes('application/pdf'))
        .map(it=> ({ id: it.id, name: it.name, downloadUrl: it.downloadUrl, webUrl: it.webUrl }));
    }

    handleRowAction(event){
      const { action, id } = event.detail;
      const file = this.data.find(d=>d.id===id);
      if(!file) return;
      if(action==='Відкрити'){
        if(file.folder){
          this.openFolder(file, false);
        } else {
          this.openPreview(file);
        }
      }
      if(action==='Завантажити' && file.downloadUrl){
        this.downloadFile(file.downloadUrl, '_blank');
      }
    }

    handleRowOpen(event){
      const id = event.detail.id;
      const file = this.data.find(d=>d.id===id);
      if(!file) return;
      if(file.folder){
        this.openFolder(file, false);
      } else {
        this.openPreview(file);
      }
    }

    handleRowClick(event){
      const id = event.detail && event.detail.id;
      if(!id) return;
      const fakeEvent = { target: { dataset: { id } } };
      this.selectItemHandler(fakeEvent);
    }

    generateMockForFolder(folderId){
      const now = new Date();
      const formatDate = (d)=> d.toLocaleDateString('en-us', { weekday:'long', year:'numeric', month:'short', day:'numeric'});
      if(folderId==='root'){
        const raw = [
          { id:'f1', name:'Projects', folder:{}, createdDateTime: now, lastModifiedBy:{ user:{ displayName: 'Admin' } }, listItem:{ fields:{ LastModifiedBy:'Admin' } } },
          { id:'doc1', name:'Specification.docx', downloadUrl:'https://example.com/spec.docx', file:{ mimeType:'application/vnd.openxmlformats-officedocument.wordprocessingml.document' }, createdDateTime: now, lastModifiedBy:{ user:{ displayName: 'John Doe' } }, listItem:{ fields:{ LastModifiedBy:'John Doe' } }, webUrl:'https://example.com/spec' },
          { id:'sheet1', name:'Report.xlsx', downloadUrl:'https://example.com/report.xlsx', file:{ mimeType:'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' }, createdDateTime: now, lastModifiedBy:{ user:{ displayName: 'Jane Smith' } }, listItem:{ fields:{ LastModifiedBy:'Jane Smith' } }, webUrl:'https://example.com/report' },
          { id:'img1', name:'Photo.png', downloadUrl:'https://example.com/photo.png', file:{ mimeType:'image/png' }, createdDateTime: now, lastModifiedBy:{ user:{ displayName: 'Marketing' } }, listItem:{ fields:{ LastModifiedBy:'Marketing' } }, webUrl:'https://example.com/photo' },
          { id:'pdf1', name:'Brochure.pdf', downloadUrl:'https://example.com/brochure.pdf', file:{ mimeType:'application/pdf' }, createdDateTime: now, lastModifiedBy:{ user:{ displayName: 'Sales' } }, listItem:{ fields:{ LastModifiedBy:'Sales' } }, webUrl:'https://example.com/brochure' }
        ];
        return this.parseResponce(raw);
      }
      if(folderId==='f1'){
        const raw = [
          { id:'subf1', name:'2025', folder:{}, createdDateTime: now, lastModifiedBy:{ user:{ displayName: 'PM' } }, listItem:{ fields:{ LastModifiedBy:'PM' } } },
          { id:'txt1', name:'Notes.txt', downloadUrl:'https://example.com/notes.txt', file:{ mimeType:'text/plain' }, createdDateTime: now, lastModifiedBy:{ user:{ displayName: 'PM' } }, listItem:{ fields:{ LastModifiedBy:'PM' } }, webUrl:'https://example.com/notes' }
        ];
        return this.parseResponce(raw);
      }
      if(folderId==='subf1'){
        const raw = [
          { id:'ppt1', name:'Kickoff.pptx', downloadUrl:'https://example.com/kickoff.pptx', file:{ mimeType:'application/vnd.openxmlformats-officedocument.presentationml.presentation' }, createdDateTime: now, lastModifiedBy:{ user:{ displayName: 'Presenter' } }, listItem:{ fields:{ LastModifiedBy:'Presenter' } }, webUrl:'https://example.com/kickoff' }
        ];
        return this.parseResponce(raw);
      }
      return [];
    }
    // no-op handlers kept minimal; upload/create removed as unused

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

    

    // removed convertToPdf (unused)

    /*----------------------------------------------------------------
    
    Drag and Drop

    ----------------------------------------------------------------*/
    

    handlerOnDragStart(event){
        const draggedId = event.target.dataset.id;
        if(this.selectedData.filter(item=>item.id === draggedId).length<1){
            const found = this.data.filter(item=>item.id === draggedId)[0];
            if(found){
                this.selectedData.push(found);
            }
        }
        // prepare PDF payload for drop targets (e.g., mergerPdf)
        const pdfItems = this.selectedData.filter(it=> it.file && it.file.mimeType && it.file.mimeType.includes('application/pdf'))
            .map(it=>({ id: it.id, name: it.name, downloadUrl: it.downloadUrl, webUrl: it.webUrl }));
        try{
            event.dataTransfer.setData('application/json', JSON.stringify({ type: 'pdf-list', items: pdfItems }));
        }catch(e){ /* no-op */ }
    }

    handlerOnDragEnter(event){
        //console.log('handlerOnDragEnter');
        //console.log(event.target.dataset.id);
    }

    handlerOnDragEnd(event){
        //console.log('handlerOnDragEnd');
        //console.log(event.target.dataset.id);
        //event.currentTarget.classList.remove("dragged");
    }

    handlerOnDrop(event){
        console.log('handlerOnDrop');
        console.log(event.target.dataset.id);
        let itemId = event.target.dataset.id;
        let item = this.data.filter(elem=>elem.id===itemId)[0];
        if(this.selectedData.filter(elem=>elem.id===itemId).length>0){
            return;
        }
        if((item.folder!=null||item.folder!=undefined)){
            this.doMove(itemId);
        }
    }

    handlerOnDropPath(event){
        console.log('handlerOnDrop');
        console.log(event.target.dataset.id);
        let itemId = event.target.dataset.id;
        if(this.folderPath[this.folderPath.length-1].id!=itemId)
            this.doMove(itemId);
    }

    

    handlerOnDragOver(event){
        event.preventDefault();
    }

    // removed document flow (unused)

    // removed search integration (unused)

    handleFilterChange(event){
        const { search, showFolders, showFiles, type } = event.detail;
        const typeToIconMap = {
            'pdf': 'pdf.png',
            'docx': 'docx.png',
            'xlsx': 'xlsx.png',
            'image': 'photo.png',
            'txt': 'txt.png'
        };

        this.data = this.masterData.filter(item => {
            const isFolder = (item.folder !== undefined && item.folder !== null);
            if (isFolder && !showFolders) return false;
            if (!isFolder && !showFiles) return false;

            if (type && type !== '') {
                if (isFolder) return false; 
                if (item.iconName !== typeToIconMap[type]) return false;
            }

            if (search && search.trim() !== '') {
                if (!item.name.toLowerCase().includes(search.toLowerCase())) {
                    return false;
                }
            }

            return true;
        });
    }

}